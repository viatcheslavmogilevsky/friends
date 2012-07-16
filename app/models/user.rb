class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :first_name, :nickname,
  				:description, :avatar

  validate :name, {presence: true, length: {maximum: 30}}
  validate :first_name, {presence: true, length: {maximum: 30}}
  validate :nickname, {length: {maximum: 30}}

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" },
    :storage => :s3,
    :bucket => 'mogilevsky',
    :s3_credentials => {:access_key_id => ENV['S3_KEY'], :secret_access_key => ENV['S3_SECRET']}

  has_many :user_friendships, :dependent => :destroy
  has_many :friendship_notifications, :class_name => "UserFriendship", 
  	:foreign_key => "target_user_id"
  has_and_belongs_to_many :friends, :class_name => "User",
    :foreign_key => "user_id",
    :association_foreign_key => "other_user_id",
    :join_table => :friendships
  has_many :target_users, :through => :user_friendships,
  	:source => :target_user
  has_many :posts, :order => "updated_at DESC"
  has_many :wall_items, :class_name => "Post", :foreign_key => "target_user_id",    
           :order => "updated_at DESC", :after_add => :notify_self_about_post
  has_many :inbox_messages, :class_name => "Message", :foreign_key => "target_user_id",
      	   :order => "updated_at DESC"
  has_many :outbox_messages, :class_name => "Message", :order => "updated_at DESC"
  has_many :notifications, :foreign_key => "target_user_id", :order => "created_at DESC"
  has_many :proper_notifications, :class_name => "Notification"
  has_many :likes
  has_many :comments
  has_many :photo_albums
  has_many :photos
  paginates_per 10

  def notify_self_about_post(post)
    if post.user != post.target_user
      post.create_notification
      post.user.proper_notifications << post.notification
      self.notifications << post.notification
    end 
  end

  def inbox
    self.inbox_messages.skip_marked(self.id)
  end         

  def outbox
    self.outbox_messages.skip_marked(self.id)
  end

  def send_message(some_user,msg)
    transaction do
      some_user.inbox_messages << msg
      self.proper_notifications << msg.notification
      some_user.notifications << msg.notification
    end
  end

  def dialog_at(some_user)
    var = Message.where("(user_id = ? AND target_user_id = ?) OR (user_id = ? AND target_user_id = ?)",
      self.id,some_user.id,some_user.id,self.id)
    var = var.skip_marked(self.id).order("updated_at DESC")
  end

  def delete_friend(some_user)
  	self.friends.delete(some_user)
  	some_user.friends.delete(self)
  end

  def feed_items
    var = Post.joins(:user).where(:user_id => (self.friend_ids<<self.id))
    var = var.where("posts.user_id = posts.target_user_id OR posts.target_user_id IS ?",nil)
    var.order("updated_at DESC")
  end

  def destroy_message_notifications(user)
    user.proper_notifications.where({:notificable_type => "Message",
      :target_user_id => self.id}).destroy_all.size
  end
    
  def full_name
    "#{self.name} #{self.nickname} #{self.first_name}" 
  end

  def fname
    "#{self.name} #{self.first_name}"
  end

  def friend?(some_user)
    self.friends(true).exists?(some_user)
  end

  def target_user?(some_user)
    self.user_friendships(true).find_by_target_user_id(some_user.id)
  end

  def candidate?(some_user)
    some_user.user_friendships(true).find_by_target_user_id(self.id)
  end

  def self.search(search_string)
    User.find(:all,
      :conditions => ["(name LIKE ?) OR (first_name LIKE ?) OR (nickname LIKE ?) OR (description LIKE ?)",
      "%#{search_string}%","%#{search_string}%","%#{search_string}%","%#{search_string}%"])
  end
end

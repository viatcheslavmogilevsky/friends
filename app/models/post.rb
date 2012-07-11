class Post < ActiveRecord::Base
  attr_accessible :content, :photo

  has_many :comments, :as => :commentable

  belongs_to :user
  belongs_to :target_user, :class_name => "User"

  has_one :notification, :as => :notificable
  has_many :likes, :as => :likeable
  validates :content, :presence => true

  has_attached_file :photo,
    :storage => :s3,
    :bucket => 'mogilevsky',
    :s3_credentials => "config/s3.yml"


  def create_on_user(user1,user2)
  	if self.save
  		some_user = User.find(user1 || user2.id)
  		some_user.wall_items << self
  		if user1 and user1 != user2.id
  			self.create_notification
        self.user.proper_notifications.push(self.notification) 
  			some_user.notifications.push(self.notification)
  		end
  		true
  	else
  		false
  	end
  end


  def cant_like?(some_user_id)
    !self.likes.where(:user_id => some_user_id).exists?
  end

  def self.like(resource_id,from)
    like = Like.toggle_like(resource_id,"Post",from)
    if like
      post = Post.find(resource_id)
      like.update_notification(post)
    end
  end

end

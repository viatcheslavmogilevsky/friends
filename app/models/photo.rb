class Photo < ActiveRecord::Base
  attr_accessible :description, :content

  has_many :likes, :as => :likeable, :dependent => :destroy, :after_add => :notify_owner_about_like
  has_many :comments, :as => :commentable, :dependent => :destroy, :after_add => :notify_owner_about_comment

  belongs_to :user
  belongs_to :photo_album
  after_create :set_user

  has_attached_file :content, :styles => {:thumb => "100x100>" },
    :storage => :s3,
    :bucket => 'mogilevsky',
    :s3_credentials => "config/s3.yml"
  validates_attachment :content, :presence => true

  # def self.like(resource_id,from)
  #   like = Like.toggle_like(resource_id,"Photo",from)
  #   if like
  #     photo = Photo.find(resource_id)
  #     like.update_notification(photo)
  #   end
  # end

  def cant_like?(some_user_id)
    !self.likes.where(:user_id => some_user_id).exists?
  end

  def set_user
  	User.find(photo_album.user).photos << self
  end

  def notify_owner_about_comment(comment)
    if self.user != comment.user
      comment.create_notification
      comment.user.proper_notifications << comment.notification
      self.user.notifications << comment.notification
    end 
  end

  def notify_owner_about_like(like)
    if self.user != like.user
      like.create_notification
      like.user.proper_notifications << like.notification
      self.user.notifications << like.notification
    end 
  end
end

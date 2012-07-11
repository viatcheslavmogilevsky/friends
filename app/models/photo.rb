class Photo < ActiveRecord::Base
  attr_accessible :description, :content

  has_many :likes, :as => :likeable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy

  belongs_to :user
  belongs_to :photo_album
  after_create :set_user

  has_attached_file :content, :styles => {:thumb => "100x100>" },
    :storage => :s3,
    :bucket => 'mogilevsky',
    :s3_credentials => "config/s3.yml"
  validates_attachment :content, :presence => true

  def self.like(resource_id,from)
    like = Like.toggle_like(resource_id,"Photo",from)
    if like
      photo = Photo.find(resource_id)
      like.update_notification(photo)
    end
  end

  def cant_like?(some_user_id)
    !self.likes.where(:user_id => some_user_id).exists?
  end

  def set_user
  	User.find(photo_album.user).photos << self
  end
end

class Photo < ActiveRecord::Base
  include Likeable
  include Commentable
  attr_accessible :description, :content

  has_many :likes, :as => :likeable, :dependent => :destroy, :after_add => :notify_owner_about_like
  has_many :comments, :as => :commentable, :dependent => :destroy, :after_add => :notify_owner_about_comment

  belongs_to :user
  belongs_to :photo_album
  after_create :set_user

  has_attached_file :content, :styles => {:thumb => "100x100>" },
    :storage => :s3,
    :bucket => 'mogilevsky',
    :s3_credentials => {:access_key_id => ENV['S3_KEY'], :secret_access_key => ENV['S3_SECRET']}
  validates_attachment :content, :presence => true

  def set_user
  	User.find(photo_album.user).photos << self
  end

end

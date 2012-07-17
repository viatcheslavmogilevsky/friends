class Post < ActiveRecord::Base
  include Likeable
  include Commentable
  attr_accessible :content, :photo

  has_many :comments, :as => :commentable, :after_add => :notify_owner_about_comment

  belongs_to :user
  belongs_to :target_user, :class_name => "User"

  has_one :notification, :as => :notificable, :dependent => :destroy
  has_many :likes, :as => :likeable, :dependent => :destroy, :after_add => :notify_owner_about_like
  validates :content, :presence => true


  has_attached_file :photo,
    :storage => :s3,
    :bucket => 'mogilevsky',
    :s3_credentials => {:access_key_id => ENV['S3_KEY'], :secret_access_key => ENV['S3_SECRET']}
  paginates_per 5  

end

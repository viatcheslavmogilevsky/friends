class Comment < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user
  belongs_to :target_user, :class_name => "User"
  belongs_to :commentable, :polymorphic => true

  has_one :notification, :as => :notificable, :dependent => :destroy
  has_many :likes, :as => :likeable
  validates :content, :presence => true

  after_create :make_notification

  def make_notification
  	 self.create_notification
  end

  def update_notification(from,to)
  	transaction do
  		from.comments << self
  		from.proper_notifications << self.notification
  		to.notifications << self.notification if from != to
  	end
  end

  def self.like(resource_id,from)
    like = Like.toggle_like(resource_id,"Comment",from)
    if like
      comment = Comment.find(resource_id)
      like.update_notification(comment)
    end
  end

  def cant_like?(some_user_id)
    !self.likes.where(:user_id => some_user_id).exists?
  end


end

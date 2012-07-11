class Like < ActiveRecord::Base
  # attr_accessible :title, :body
  has_one :notification, :as => :notificable, :dependent => :destroy
  belongs_to :likeable, :polymorphic => true
  belongs_to :user 

  after_create :make_notification
  
  def make_notification
  	self.create_notification
  end

  def update_notification(to)
  	transaction do
  		to.likes << self
  		self.user.proper_notifications << self.notification
   		to.user.notifications << self.notification if to.user != self.user
  	end
  end

  def self.toggle_like(likeable_id,likeable_type,user_id)
  	like = Like.where("likeable_id = ? AND likeable_type = ? AND user_id = ?",
  		likeable_id,likeable_type,user_id).first
  	if like
  		like.destroy
  		false
  	else
  		User.find(user_id).likes.create
  	end
  end
end


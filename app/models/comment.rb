class Comment < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user
  belongs_to :target_user, :class_name => "User"
  belongs_to :commentable, :polymorphic => true

  has_one :notification, :as => :notificable, :dependent => :destroy
  has_many :likes, :as => :likeable, :after_add => :notify_owner_about_like 
  validates :content, :presence => true

  #after_create :make_notification
  paginates_per 5

  # def make_notification
  # 	 self.create_notification
  #    self.user.proper_notifications << self.notification
  # end

  # def update_notification(from,to)
  # 	transaction do
  # 		from.comments << self
  # 		from.proper_notifications << self.notification
  # 		to.notifications << self.notification if from != to
  # 	end
  # end

  # def self.like(resource_id,from)
  #   like = Like.toggle_like(resource_id,"Comment",from)
  #   if like
  #     comment = Comment.find(resource_id)
  #     like.update_notification(comment)
  #   end
  # end

  def cant_like?(some_user_id)
    !self.likes.where(:user_id => some_user_id).exists?
  end

  def notify_owner_about_like(like)
    if self.user != like.user
      like.create_notification
      like.user.proper_notifications << like.notification
      self.user.notifications << like.notification
    end 
  end


end

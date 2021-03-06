class Comment < ActiveRecord::Base
  include Likeable
  extend MultiNested
  

  attr_accessible :content
  belongs_to :user
  belongs_to :target_user, :class_name => "User"
  belongs_to :commentable, :polymorphic => true

  has_one :notification, :as => :notificable, :dependent => :destroy
  has_many :likes, :as => :likeable, :after_add => :notify_owner_about_like 
  validates :content, :presence => true

  paginates_per 5

  def save_on_parent(parent_type,parent_id)
  	parent = Comment.get_parent(parent_type,parent_id)
  	if self.save
  		parent.comments << self
  	else
  		false
  	end
  end

end

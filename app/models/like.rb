class Like < ActiveRecord::Base
  # attr_accessible :title, :body
  AVAILABLE_OWNERS = {"Comment"=>Comment,"Post"=>Post,"Photo"=>Photo}

  has_one :notification, :as => :notificable, :dependent => :destroy
  belongs_to :likeable, :polymorphic => true
  belongs_to :user 

  def self.toggle_like(likeable_id,likeable_type,some_user)
    return false unless AVAILABLE_OWNERS.keys.include?(likeable_type)
  	like = some_user.likes.where("likeable_id = ? AND likeable_type = ?",
  		likeable_id,likeable_type).first
  	if like
  	  like.destroy
  	else
  		like = some_user.likes.create
      parent = AVAILABLE_OWNERS[likeable_type].find(likeable_id)            
      parent.likes << like
  	end
    if likeable_type == "Comment"
      like.likeable.commentable
    else 
      like.likeable
    end 
  end
end


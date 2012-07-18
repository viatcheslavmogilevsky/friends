class Like < ActiveRecord::Base
  extend MultiNested

  has_one :notification, :as => :notificable, :dependent => :destroy
  belongs_to :likeable, :polymorphic => true
  belongs_to :user 

  def self.toggle_like(likeable_id,likeable_type,some_user)
    return false unless parent_type_exists?(likeable_type)
  	like = some_user.likes.where("likeable_id = ? AND likeable_type = ?",
  		likeable_id,likeable_type).first
  	if like
  	  like.destroy
  	else
  		like = some_user.likes.create
      parent = get_parent(likeable_type,likeable_id)          
      parent.likes << like
  	end
    if likeable_type == "Comment"
      parent.commentable
    else 
      parent
    end 
  end


end


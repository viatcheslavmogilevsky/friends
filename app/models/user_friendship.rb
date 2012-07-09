class UserFriendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :target_user, :class_name => "User"
  before_save :check_friends
  def accept
  	user.friends << target_user
  	target_user.friends << user
  	self.destroy
  end
  protected
  def check_friends
  	!self.user.friend?(self.target_user) && 
  	      !self.target_user.target_user?(self.user)
  end
end

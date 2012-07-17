module Likeable
	
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
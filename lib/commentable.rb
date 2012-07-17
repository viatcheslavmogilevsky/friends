module Commentable

  def notify_owner_about_comment(comment)
    if self.user != comment.user
      comment.create_notification
      comment.user.proper_notifications << comment.notification
      self.user.notifications << comment.notification
    end
  end
  
end
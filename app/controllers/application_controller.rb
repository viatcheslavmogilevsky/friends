class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from ActiveRecord::RecordNotSaved, :with => :access_denied

  before_filter :get_notifications

  private
 
  def record_not_found
    render :text => "404 Not Found", :status => 404
  end

  def access_denied
  	render :text => "access denied", :status => 404 
  end

  def get_notifications
    if user_signed_in?
      @invite_count = current_user.friendship_notifications.size
      @notification_count = current_user.notifications.size
    end
  end
end

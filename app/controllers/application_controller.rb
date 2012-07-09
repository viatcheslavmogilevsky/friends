class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from ActiveRecord::RecordNotSaved, :with => :access_denied

  private
 
  def record_not_found
    render :text => "404 Not Found", :status => 404
  end

  def access_denied
  	render :text => "access denied", :status => 404 
  end
end

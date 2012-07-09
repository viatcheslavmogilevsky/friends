class UserFriendshipsController < ApplicationController
  before_filter :authenticate_user!
  def accept
  	@user_friendship = UserFriendship.find(params[:id])
  	if @user_friendship.target_user == current_user
  		@user_friendship.accept
  		redirect_to friends_path
  	else
  		flash[:alert] = "Access denied!"
  		redirect_to root_path
  	end
  end

  def cancel
  	@user_friendship = UserFriendship.find(params[:id])
  	if (@user_friendship.target_user == current_user) or (@user_friendship.user == current_user)
  		@user_friendship.destroy
  		redirect_to friends_path
  	else
  		flash[:alert] = "Access denied!"
  		redirect_to root_path
  	end
  end
end

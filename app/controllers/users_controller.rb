class UsersController < ApplicationController
	before_filter :authenticate_user!

	def index
		@users = User.all
		@title = "People"
	end
	
	def delete
		user = User.find(params[:id])
		current_user.delete_friend(user)
		redirect_to :back
	end

	def create_invite
		user = User.find(params[:id])
		current_user.target_users << user
		redirect_to user_path(user)
	end

	def search
		@search = params[:search]
		if params[:search]
			@users = User.search(params[:search])
		else
			flash[:alert] = "Search field is empty!"
			redirect_to users_path 
		end
	end

	def show
		@user = User.find(params[:id])
		redirect_to(profile_path) if @user == current_user
		@title = @user.full_name
		@items = @user.wall_items
	end
end

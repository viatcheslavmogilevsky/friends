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
		@post = current_user.posts.build
	end

	def dialog
		@user = User.find(params[:id])
		@items = current_user.dialog_at(@user)
		@title = current_user.name + ' and ' + @user.name
		current_user.destroy_certain_notifications("Message",@user.id)
	end

	def send_message
		@user = User.find(params[:id])
		current_user.send_message(@user,params[:content]) 
		redirect_to dialog_user_path(@user)
	end

	def new_message
		@user = User.find(params[:id])
		@title = "New message to #{@user.name}"
	end
end

class UsersController < ApplicationController
	before_filter :authenticate_user!
	before_filter :do_not_talking_self, :only => [:new_message, :send_message, 
		:create_invite, :dialog]

	def index
		@users = User.all
		@title = "People"
	end
	
	def delete
		user = User.find(params[:id])
		current_user.delete_friend(user)
		redirect_to user_path(user)
	end

	def create_invite
		current_user.target_users << @user
		redirect_to user_path(@user)
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
		@title = @user.full_name
		@items = @user.wall_items.page(params[:page])
		@post = current_user.posts.new
	end

	def dialog
		@items = current_user.dialog_at(@user).page(params[:page])
		@title = current_user.name + ' and ' + @user.name
		@notification_count -= current_user.destroy_message_notifications(@user)
		@message = current_user.outbox_messages.new
	end

	def send_message
		message = current_user.outbox_messages.build(:content => params[:content])
		if message.save
			current_user.send_message(@user,message) 
			redirect_to dialog_user_path(@user)
		else
			render 'new_message'
		end
	end

	def new_message
		@title = "New message to #{@user.name}"
		@message = current_user.outbox_messages.new
	end

	private
	def do_not_talking_self
		@user = User.find(params[:id])
		if current_user == @user
			render :status => 404, :text => "invalid operation"
		end 
	end
end

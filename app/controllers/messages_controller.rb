class MessagesController < ApplicationController
	before_filter :authenticate_user!
	before_filter :find_other_user, :only => [:show, :mark_to_delete]
	before_filter :do_not_talking_self, :only => [:new, :create]

	def show
	end

	def mark_to_delete
		@message.mark_to_delete(current_user)
		redirect_to dialog_user_path(@user)
	end

	def create
		@message = current_user.outbox_messages.build(params[:message])
		if @message.save
			current_user.send_message(@user,@message) 
			redirect_to dialog_user_path(@user)
		else
			render 'new'
		end
	end

	def new
		@title = "New message to #{@user.name}"
		@message = current_user.outbox_messages.new
	end

	private

	def find_other_user
		@message = Message.find(params[:id])
		if @message.user == current_user
			@user = @message.target_user
		elsif current_user == @message.target_user
			@user = @message.user
		else
			render :status => 404, :text => "access denied" 
		end
	end

	def do_not_talking_self
		@user = User.find(params[:user_id])
		if current_user == @user
			render :status => 404, :text => "invalid operation"
		end 
	end
end

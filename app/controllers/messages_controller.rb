class MessagesController < ApplicationController
	before_filter :authenticate_user!
	before_filter :find_other_user

	def show

	end

	def mark_to_delete
		@message.mark_to_delete(current_user)
		redirect_to dialog_user_path(@user)
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
end

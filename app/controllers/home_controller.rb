class HomeController < ApplicationController
	before_filter :authenticate_user!, :except => [:index]

	def index
		if user_signed_in?
			redirect_to feed_path
		else
			@title = "Welcome to the Friends!"
		end 
	end

	def feed
		@title = current_user.full_name
		@items = current_user.feed_items.page(params[:page])
		@post = current_user.posts.new
		@user = current_user
	end

	def friends
		@title = 'Your friends'
		@friends = current_user.friends.page(params[:page])
		@invites = current_user.friendship_notifications.includes(:user)
	end

	def inbox
		@title = "Inbox messages"
		@messages = current_user.inbox.page(params[:page])
	end

    def outbox
     	@title = "Outbox messages"
     	@messages = current_user.outbox.page(params[:page])
    end

    def notifications
    	@title = "Latest notifications"
    	@items = current_user.notifications.includes(:notificable, :user).destroy_all
    end
end

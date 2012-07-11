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
		@items = current_user.feed_items
		@post = current_user.posts.build
	end

	def profile
		@title = current_user.name
		@items = current_user.wall_items
		@post = current_user.posts.build
		current_user.destroy_certain_notifications("Post")
	end

	def friends
		@title = 'Your friends'
		@friends = current_user.friends
		@invites = current_user.friendship_notifications.includes(:user)
	end

	def inbox
		@title = "Inbox messages"
		@items = current_user.inbox
		current_user.destroy_certain_notifications("Message")
	end

    def outbox
     	@title = "Outbox messages"
     	@items = current_user.outbox
    end

    def notifications
    	@title = "Latest notifications"
    	@items = current_user.notifications.includes(:notificable, :user).destroy_all
    end
end

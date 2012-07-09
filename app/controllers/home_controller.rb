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
	end

	def profile
		@title = current_user.name
		@items = current_user.wall_items
	end

	def friends
		@title = 'Your friends'
		@friends = current_user.friends
	end
end

class LikesController < ApplicationController
	before_filter :authenticate_user!
   
	def toggle
		unless res = Like.toggle_like(params[:id],params[:likeable],current_user)
			render :status => 404, :text => "404 Not Found"
		else
			redirect_to res 	
		end
	end
end

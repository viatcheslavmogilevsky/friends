class PostsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :check_user, :only => [:edit,:update,:destroy]

	def create
		@post = current_user.posts.build(params[:post])
		if @post.create_on_user(params[:user_id],current_user) 
			if params[:user_id]
				redirect_to user_path(params[:user_id]) 
			else
				redirect_to feed_path
			end
		else
			render 'shared/_post_form'
		end
	end

	def toggle_like
		Post.like(params[:id],current_user.id)
		redirect_to post_path(params[:id])
	end

	def edit 
		render 'shared/_post_form'
	end

	def update
		if @post.update_attributes(params[:post])
			redirect_to post_path(@post)
		else
			render 'shared/_post_form'
		end
	end

	def destroy
		@post.destroy
		redirect_to root_path
	end

	def show
		@parent = @post = Post.find(params[:id])
		@comments = @post.comments.includes(:user)
		@comment = current_user.comments.build
	end

	private

	def check_user
		@post = Post.find(params[:id])
		if @post.user != current_user
			render :status => 404
		end
	end
end

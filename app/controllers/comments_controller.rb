class CommentsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :check_user, :only => [:edit,:update]
	before_filter :set_parent
	
	def create
		@comment = @parent.comments.build(params[:comment])
		if @comment.save
			@comment.update_notification(current_user,@parent.user)
			redirect_to_parent_path
		else
			render 'shared/_comment_form'
		end
	end

	def toggle_like
		Comment.like(params[:id],current_user.id)
		redirect_to_parent_path
	end

	def edit
		render 'shared/_comment_form'
	end

  	def update 
  		if @comment.update_attributes(params[:comment])
  			redirect_to_parent_path
  		else
  			render 'shared/_comment_form'
  		end	
  	end

  	def destroy
  		@comment = Comment.find(params[:id])
  		if @comment.user != current_user and @parent.user != current_user
  			render :text => "access denied", :status => 404 
  		else
  			@comment.destroy
  			redirect_to_parent_path
  		end	
  	end

  	private 

  	def check_user
  		@comment = Comment.find(params[:id])
	   	if @comment.user != current_user
		    render :text => "access denied", :status => 404	
		  end
  	end

  	def redirect_to_parent_path
  		if params[:in_post] 
  			redirect_to post_path(@parent)
  		else
  			redirect_to photo_path(@parent)
  		end
  	end

  	def set_parent
  		if params[:in_post]
  			@parent = Post.find(params[:post_id])
  		else
  			@parent = Photo.find(params[:photo_id])
  		end
  	end

end

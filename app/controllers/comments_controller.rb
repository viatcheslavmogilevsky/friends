class CommentsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :check_user, :only => [:edit,:update]

  # AVAILABLE_OWNERS = {"Post"=>Post,"Photo"=>Photo}
	
	def create
    unless Comment.parent_type_exists?(params[:commentable],"Comment")
      render :status => 404, :text => "Commentable not found"
    end
    @comment = current_user.comments.new(params[:comment])
    if @comment.save_on_parent(params[:commentable],params[:post_id] || params[:photo_id])
      redirect_to @comment.commentable
    else
      render 'shared/_comment_form'
    end
	end

	def edit
		render 'shared/_comment_form'
	end

  	def update 
  		if @comment.update_attributes(params[:comment])
  			redirect_to @parent
  		else
  			render 'shared/_comment_form'
  		end	
  	end

  	def destroy
  		@comment = Comment.find(params[:id])
      parent = @comment.commentable
  		if @comment.user != current_user and parent.user != current_user
  			render :text => "access denied", :status => 404 
  		else
  			@comment.destroy
  			redirect_to parent
  		end	
  	end

  	private 

  	def check_user
  		@comment = Comment.find(params[:id])
	   	if @comment.user != current_user
		    render :text => "access denied", :status => 404	
      else 
        @parent = @comment.commentable
		  end
  	end
end

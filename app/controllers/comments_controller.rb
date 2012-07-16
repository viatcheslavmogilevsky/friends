class CommentsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :check_user, :only => [:edit,:update]

  AVAILABLE_OWNERS = {"Post"=>Post,"Photo"=>Photo}
	
	def create
    if AVAILABLE_OWNERS.keys.include?(params[:commentable])
      @parent = AVAILABLE_OWNERS[params[:commentable]].find(params[:post_id] || params[:photo_id])
      @comment = current_user.comments.new(params[:comment])
      if @comment.save
        @parent.comments << @comment
        redirect_to @parent
      else
       render 'shared/_comment_form'
      end
    else
      render :status => 404, :text => "Commentable not found"
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

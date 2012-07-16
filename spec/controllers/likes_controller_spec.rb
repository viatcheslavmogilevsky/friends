require 'spec_helper'

describe LikesController do

	describe "toggle action" do

		before(:each) do
			@user = FactoryGirl.create(:user)
			@post = FactoryGirl.create(:post, :user => @user, :target_user => @user)
			sign_in(@user)
		end

		describe "for post" do

			it "should be success" do
				lambda do
					put :toggle, :id => @post.id, :likeable => "Post"
					response.should redirect_to(@post)
				end.should change(@post.likes, :count).by(1)	
			end

			it "should be success on two toggles" do
				lambda do
					put :toggle, :id => @post.id, :likeable => "Post"
					put :toggle, :id => @post.id, :likeable => "Post"
					response.should redirect_to(@post)
				end.should_not change(@post.likes, :count)
			end

		end

		describe "for comment" do

			before(:each) do
				@comment = FactoryGirl.create(:comment, :user => @user, :commentable => @post)
			end

			it "should be success" do
				lambda do
					put :toggle, :id => @comment.id, :likeable => "Comment"
					response.should redirect_to(@post)
				end.should change(@comment.likes, :count).by(1)	
			end

			it "should be success on two toggles" do
				lambda do
					put :toggle, :id => @comment.id, :likeable => "Comment"
					put :toggle, :id => @comment.id, :likeable => "Comment"
					response.should redirect_to(@post)
				end.should_not change(@comment.likes, :count)
			end

		end	
	end

end
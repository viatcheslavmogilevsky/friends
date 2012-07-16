require 'spec_helper'

describe CommentsController do 

	before(:each) do
		@user1 = FactoryGirl.create(:user)
		@user2 = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
		@post = FactoryGirl.create(:post, :user => @user1, :target_user => @user1)
		@comment1 = FactoryGirl.create(:comment, :user => @user2, :commentable => @post)
		@comment2 = FactoryGirl.create(:comment, :user => @user1, :commentable => @post)
	end

	describe "destroy action" do
		it "should allow to destroy comment for comment author" do
			sign_in(@user2)
			delete :destroy, :id => @comment1.id
			response.should redirect_to(@post)
		end

		it "should allow to destroy comment for post author" do
			sign_in(@user1)
			delete :destroy, :id => @comment1.id
			response.should redirect_to(@post)
		end

		it "should not allow to destroy other comment for comment1 author" do
			sign_in(@user2)
			delete :destroy, :id => @comment2.id
			response.status.should be_equal(404) 
		end	
	end

	describe "edit action" do
		it "should allow to edit comment for comment author" do
			sign_in(@user2)
			get :edit, :id => @comment1
			response.should be_success
		end	

		it "should not allow to edit comment for post author" do
			sign_in(@user1)
			get :edit, :id => @comment1.id
			response.status.should be_equal(404)
		end
	end

	describe "update action" do
		it "should allow to update comment for comment author" do
			sign_in(@user2)
			put :update, :id => @comment1.id, :comment => FactoryGirl.attributes_for(:comment)
			response.should redirect_to(@post)
		end

		it "should not allow to update comment for post author" do
			sign_in(@user1)
			put :update, :id => @comment1.id, :comment => FactoryGirl.attributes_for(:comment)
			response.status.should be_equal(404)
		end
	end

	describe "create action" do
		it "should allow to create comment on post" do
			sign_in(@user1)
			post :create, :comment => FactoryGirl.attributes_for(:comment), :post_id => @post.id,
				:commentable => "Post"
			response.should redirect_to(@post)
		end

		it "should allow to create comment on photo" do
			@photo_album = FactoryGirl.create(:photo_album, :user => @user1)
			@photo = FactoryGirl.create(:photo, :photo_album => @photo_album, :user => @user1,
				:content => fixture_file_upload("app/assets/images/rails.png","image/png"))
			sign_in(@user1)
			post :create, :comment => FactoryGirl.attributes_for(:comment), :photo_id => @photo.id,
				:commentable => "Photo"
			response.should redirect_to(@photo)
		end
		
	end


end

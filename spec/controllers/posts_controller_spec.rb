require 'spec_helper'

describe PostsController do

	before(:each) do
			@user1 = FactoryGirl.create(:user)
			@user2 = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
			@post = FactoryGirl.create(:post, :user => @user1, :target_user => @user1)
	end

	describe "'POST' create" do

		it "should redirect to target user when send valid data to self" do
			sign_in(@user1)
			post :create, :user_id => @user1.id, :post => FactoryGirl.attributes_for(:post)
			response.should redirect_to(user_path(@user1))
		end

		it "should redirect to target user when send valid data to other user" do
			sign_in(@user1)
			post :create, :user_id => @user2.id, :post => FactoryGirl.attributes_for(:post)
			response.should redirect_to(user_path(@user2))
		end 

		it "should render form if send invalid data" do
			sign_in(@user1)
			post :create, :user_id => @user1.id, :post => {:content => ""}
			response.should be_success
		end	
	end

	describe "'GET' edit" do
		it "should render form for user1" do
			sign_in(@user1)
			get :edit, :id => @post.id
			response.should be_success
		end

		it "should render 404 for user2" do
			sign_in(@user2)
			get :edit, :id => @post.id
			response.status.should be_equal(404)
		end 
	end

	describe "'PUT' update" do
		it "should redirect to updated post if user1 send valid data" do
			sign_in(@user1)
			put :update, :id => @post.id, :post => FactoryGirl.attributes_for(:post)
			response.should redirect_to(post_path(@post))
		end

		it "should render 404 for user2" do
			sign_in(@user2)
			put :update, :id => @post.id, :post => FactoryGirl.attributes_for(:post)
			response.status.should be_equal(404)
		end
		
		it "should render form if user1 send invalid data" do
			sign_in(@user1)
			put :update, :id => @post.id, :post => {:content => ""}
			response.should be_success
		end		
	end

	describe "'DELETE' destroy" do
		it "should redirect to root for user1" do
			sign_in(@user1)
			delete :destroy, :id => @post.id
			response.should redirect_to(user_path(@user1))
		end

		it "should render 404 for user2" do
			sign_in(@user2)
			delete :destroy, :id => @post.id
			response.status.should be_equal(404)
		end
	end

	describe "'GET' show" do
		it "should be success for any user" do
			sign_in(@user2)
			get :show, :id => @post.id
			response.should be_success
		end 
	end

end
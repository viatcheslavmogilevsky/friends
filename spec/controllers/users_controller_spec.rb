require 'spec_helper'

describe UsersController do

	before(:each) do
		@user1  = FactoryGirl.create(:user)
	end

	describe "'GET' index" do
		it "should be success" do
			sign_in(@user1)
			get :index
			response.should be_success
		end
	end

	describe "'DELETE' delete" do
		before(:each) do
			@user2 = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
			@user1.target_users << @user2
			@user2.friendship_notifications.first.accept
		end
		it "should redirect to user which deleted from friends for user1" do
			sign_in(@user1)
			delete :delete, :id => @user2.id
			response.should redirect_to(@user2)
		end
		it "should redirect to user which deleted from friends for user2" do
			sign_in(@user2)
			delete :delete, :id => @user1.id
			response.should redirect_to(@user1)
		end  
	end

	describe "'POST' create_invite" do
		before(:each) do
			@user2 = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
		end
		it "should redirect to target user for user1" do
			sign_in(@user1)
			post :create_invite, :id => @user2.id
			response.should redirect_to(@user2)
		end
		it "should redirect to target user for user2" do
			sign_in(@user2)
			post :create_invite, :id => @user1.id
			response.should redirect_to(@user1)
		end
		it "should render 404" do
			sign_in(@user1)
			post :create_invite, :id => @user1.id
			response.status.should be_equal(404)
		end
	end

	describe "'GET' search" do
		it "should be success" do
			sign_in(@user1)
			get :search, :search => "user"
			response.should be_success
		end
		it "should redirect to friends path" do
			sign_in(@user1)
			get :search
			response.should redirect_to(users_path)
		end
	end

	describe "'GET' show" do
		it "should be success" do
			sign_in(@user1)
			get :show, :id => @user1.id
			response.should be_success
		end
	end

	describe "'GET' dialog" do
		before(:each) do
			@user2 = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
		end
		it "should be success for user1" do
			sign_in(@user1)
			get :dialog, :id => @user2.id
			response.should be_success
		end
		it "should be success for user2" do
			sign_in(@user2)
			get :dialog, :id => @user1.id
			response.should be_success
		end
		it "should render 404" do
			sign_in(@user1)
			get :dialog, :id => @user1.id
			response.status.should be_equal(404)
		end
	end

end
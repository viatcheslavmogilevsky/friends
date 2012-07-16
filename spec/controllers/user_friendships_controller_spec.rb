require 'spec_helper'

describe UserFriendshipsController do

	before(:each) do
		@user1 = FactoryGirl.create(:user)
		@user2 = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
	end

	describe "'PUT' accept" do
		before(:each) do
			@user1.target_users << @user2
			@user_friendship = @user1.user_friendships.first
		end

		it "should accept for user2" do
			sign_in(@user2)
			put :accept, :id => @user_friendship.id
			response.should redirect_to(friends_path)
		end

		it "should redirect to root with notice for user1" do
			sign_in(@user1)
			put :accept, :id => @user_friendship.id
			response.should redirect_to(root_path)
		end
	end

	describe "'DELETE' cancel" do
		before(:each) do
			@user1.target_users << @user2
			@user_friendship = @user1.user_friendships.first
		end

		it "should redirect to friends path for user1" do
			sign_in(@user1)
			delete :cancel, :id => @user_friendship.id
			response.should redirect_to(friends_path)
		end

		it "should redirect to friends path for user2" do
			sign_in(@user2)
			delete :cancel, :id => @user_friendship.id
			response.should redirect_to(friends_path)
		end
		
		it "should redirect to root with notice for user3" do
			@user3 = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
			sign_in(@user3)
			delete :cancel, :id => @user_friendship.id
			response.should redirect_to(root_path)
		end
	end			

end
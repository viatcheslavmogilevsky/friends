require 'spec_helper'

describe UserFriendship do
	before(:each) do
		@user1 = FactoryGirl.create(:user)
		@user2 = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
		@user_friendship = FactoryGirl.create(:user_friendship, :user => @user1,
				:target_user => @user2)
		@user_friendship.accept
	end

	describe "accept" do
		it "should add to friends" do
			@user1.friend?(@user2).should be_true
			@user2.friend?(@user1).should be_true
		end
	end

	describe "check_friends" do
		it "user_friendship not saved if user added to friends yet for user1" do
			lambda do
				@user1.target_users << @user2
			end.should raise_error(ActiveRecord::RecordNotSaved)
		end
		it "user_friendship not saved if user added to friends yet for user2" do
			lambda do
				@user2.target_users << @user1
			end.should raise_error(ActiveRecord::RecordNotSaved)
		end
	end

end
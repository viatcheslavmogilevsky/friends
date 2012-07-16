require "spec_helper"

describe Comment do

	describe "cant_like" do

		before(:each) do
			@user = FactoryGirl.create(:user)
			@post = FactoryGirl.create(:post, :user => @user, :target_user => @user)
			@comment = FactoryGirl.create(:comment, :commentable => @post, :user => @user)
		end

		it "should be true" do
			@comment.cant_like?(@user.id).should be_true
		end

		it "should be false" do
			Like.toggle_like(@comment.id,"Comment",@user)
			@comment.cant_like?(@user.id).should be_false
		end

	end

	describe "notify owner about like" do

		before(:each) do
			@user1 = FactoryGirl.create(:user)
			@post = FactoryGirl.create(:post, :user => @user1, :target_user => @user1)
			@comment = FactoryGirl.create(:comment, :commentable => @post, :user => @user1)
			@user2 = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
		end
		
		it "should not notify" do
			Like.toggle_like(@comment.id,"Comment",@user1)
			@comment.user.notifications.should be_empty
		end

		it "should notify" do
			Like.toggle_like(@comment.id,"Comment",@user2)
			@comment.user.notifications.should_not be_empty
		end

	end

end
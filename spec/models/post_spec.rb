require "spec_helper"

describe Post do
	before(:each) do
		@user1 = FactoryGirl.create(:user)
		@user2 = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
		@post = FactoryGirl.create(:post, :user => @user1, :target_user => @user1)
	end
	describe "cant_like" do
		it "should be true" do
			@post.cant_like?(@user1.id).should be_true
		end
		it "should be false" do
			Like.toggle_like(@post.id,"Post",@user1)
			@post.cant_like?(@user1.id).should be_false
		end
	end
	describe "notify owner about like" do
		it "should not notify" do
			Like.toggle_like(@post.id,"Post",@user1)
			@post.user.notifications.should be_empty
		end
		it "should notify" do
			Like.toggle_like(@post.id,"Post",@user2)
			@post.user.notifications.should_not be_empty
		end
	end
	describe "notify owner about comment" do
		it "should not notify" do
			@comment = FactoryGirl.create(:comment, :user => @user1, :commentable => nil)
			@post.comments << @comment
			@post.user.notifications.should be_empty
		end
		it "should notify" do
			@comment = FactoryGirl.create(:comment, :user => @user2, :commentable => nil)
			@post.comments << @comment
			@post.user.notifications.should_not be_empty
		end
	end
end
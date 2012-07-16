require "spec_helper"

describe User do
	before(:each) do
		@user1 = FactoryGirl.create(:user)
		@user2 = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
	end
	describe "notify self about post" do
		it "should not notify" do
			@post = FactoryGirl.create(:post, :user => @user1, :target_user => nil)
			@user1.wall_items << @post
			@user1.notifications.should be_empty
		end
		it "should notify" do
			@post = FactoryGirl.create(:post, :user => @user1, :target_user => nil)
			@user2.wall_items << @post
			@user2.notifications.should_not be_empty
		end
	end
	describe "inbox and outbox and send_message" do
		before(:each) do
			@msg11 = FactoryGirl.create(:message, :user => @user1, :target_user => nil)
			@msg12 = FactoryGirl.create(:message, :user => @user1, :target_user => nil)
			@user1.send_message(@user2,@msg11)
			@user1.send_message(@user2,@msg12)
		end

		it "should be equal (inbox)" do
			@user2.inbox.should be_include(@msg11)
			@user2.inbox.should be_include(@msg12)
		end

		it "should be equal (outbox)" do
			@user1.outbox.should be_include(@msg11)
			@user1.outbox.should be_include(@msg12)
		end

		it "notify receiver" do
			@user2.notifications.should_not be_empty
		end

		it "should be equal with marked for user2" do
			@msg12.notification.destroy
			@msg12.notification = nil
			@msg12.mark_to_delete(@user2)
			@user2.inbox.should be_include(@msg11)
		end

		it "should be equal with marked for user1" do
			@msg12.notification.destroy
			@msg12.notification = nil
			@msg12.mark_to_delete(@user2)
			@user1.outbox.should be_include(@msg11)
			@user1.outbox.should be_include(@msg12)
		end

	end
	describe "dialog_at" do
		before(:each) do
			@msg1 = FactoryGirl.create(:message, :user => @user1, :target_user => nil)
			@user1.send_message(@user2,@msg1)
			@msg2 = FactoryGirl.create(:message, :user => @user2, :target_user => nil)
			@user2.send_message(@user1,@msg2)
			@msg3 = FactoryGirl.create(:message, :user => @user1, :target_user => nil)
			@user1.send_message(@user2,@msg3)
			@msg4 = FactoryGirl.create(:message, :user => @user2, :target_user => nil)
			@user2.send_message(@user1,@msg4)
		end

		it "should be equal for user1" do
			[@msg1,@msg2,@msg3,@msg4].each do |msg|
				@user1.dialog_at(@user2).should be_include(msg) 
			end
		end
		it "should be equal for user2" do
			[@msg1,@msg2,@msg3,@msg4].each do |msg|
				@user2.dialog_at(@user1).should be_include(msg) 
			end
		end
		it "should be equal with marked for user1" do
			@msg3.notification.destroy
			@msg3.notification = nil
			@msg3.mark_to_delete(@user2)
			[@msg1,@msg2,@msg3,@msg4].each do |msg|
				@user1.dialog_at(@user2).should be_include(msg) 
			end
		end	
		it "should be equal with marked for user2" do
			@msg3.notification.destroy
			@msg3.notification = nil
			@msg3.mark_to_delete(@user2)
			[@msg1,@msg2,@msg4].each do |msg|
				@user2.dialog_at(@user1).should be_include(msg) 
			end
		end	
	end
	describe "delete_friend and friend?" do
		before(:each) do
			@user1.target_users << @user2
			@user2.friendship_notifications.first.accept
		end
		it "should be true" do
			@user2.friend?(@user1).should be_true
			@user1.friend?(@user2).should be_true
		end
		it "should be false for user1" do
			@user1.delete_friend(@user2)
			@user2.friend?(@user1).should be_false
			@user1.friend?(@user2).should be_false
		end
		it "should be false for user2" do
			@user2.delete_friend(@user1)
			@user2.friend?(@user1).should be_false
			@user1.friend?(@user2).should be_false
		end
	end
	describe "feed items" do
		before(:each) do
			@user1.target_users << @user2
			@user2.friendship_notifications.first.accept
			@posts = []
			@posts[0] = FactoryGirl.create(:post,:user => @user1, :target_user => @user1)
			@posts[1] = FactoryGirl.create(:post,:user => @user1, :target_user => @user1)
			@posts[2] = FactoryGirl.create(:post,:user => @user2, :target_user => @user2)
			@posts[3] = FactoryGirl.create(:post,:user => @user2, :target_user => @user2)
			@posts[4] = FactoryGirl.create(:post,:user => @user1, :target_user => @user2)
		end

		it "should find 4 posts for user1" do
			for i in 0..3 do
				@user1.feed_items.should be_include(@posts[i])
			end
			@user1.feed_items.should_not be_include(@posts[4])
		end

		it "should find 4 posts for user1" do
			for i in 0..3 do
				@user2.feed_items.should be_include(@posts[i])
			end
			@user2.feed_items.should_not be_include(@posts[4])
		end
	end
	describe "destroy_message_notifications" do
		before(:each) do
			@post = FactoryGirl.create(:post, :user => @user1, :target_user => @user2)
			@post.comments << FactoryGirl.create(:comment, :user => @user2,
				:commentable => @post)
			@post.comments << FactoryGirl.create(:comment, :user => @user2,
				:commentable => @post)
			@msg1 = FactoryGirl.create(:message, :user => @user2, :target_user => nil)
			@user2.send_message(@user1,@msg1)
			@msg2 = FactoryGirl.create(:message, :user => @user2, :target_user => nil)
			@user2.send_message(@user1,@msg2)
		end

		it "should destroy message notifications only" do
			@user1.destroy_message_notifications(@user2).should be_equal(2)
		end

		it "should not destroy rest notifications" do
			@user1.destroy_message_notifications(@user2)
			@user1.notifications.should_not be_empty
		end
	end
	describe "target_user? and candidate?" do
		before(:each) do
			@user1.target_users << @user2
		end

		it "should be true for user1" do
			@user1.target_user?(@user2).should be_true
		end

		it "should be true for user2" do
			@user2.candidate?(@user1).should be_true
		end

		it "should raise exception for user2" do
			lambda do
				@user2.target_users << @user1
			end.should raise_error(ActiveRecord::RecordNotSaved)
		end

		it "should raise exception for user1" do
			lambda do
				@user1.target_users << @user2
			end.should raise_error(ActiveRecord::RecordNotUnique)
		end
	end

	describe "User.search" do
		it "should find a user by name" do
			User.search("John").should_not be_empty
		end
		it "should find a user by first name" do
			User.search("Smit").should_not be_empty
		end
		it "should find a user by nickname" do
			User.search("Nick").should_not be_empty
		end
		it "should find a user by description" do
			User.search("escripti").should_not be_empty
		end
	end

end
require "spec_helper"


describe Message do

	describe "mark to delete" do

		before(:each) do
			@user1 = FactoryGirl.create(:user)
			@user2 = FactoryGirl.create(:user,:email => FactoryGirl.generate(:email))
			@message = FactoryGirl.create(:message, :user => @user1, :target_user => @user2)
		end

		it "should delete message if exist notification" do
			lambda do
				@message.mark_to_delete(@user1)
			end.should change(Message, :count).by(-1)
		end

		it "should not delete message unless exist notification" do
			@message.notification.destroy
			@message.notification = nil
			lambda do
				@message.mark_to_delete(@user1)
				@user1.outbox.should_not be_include(@message)
			end.should_not change(Message, :count)
		end

		it "should delete message unless exist notification" do
			lambda do
				@message.mark_to_delete(@user1)
				@message.mark_to_delete(@user2)
				@user1.outbox.should_not be_include(@message)
				@user2.inbox.should_not be_include(@message)
			end.should change(Message, :count).by(-1)
		end

		it "should not delete message when the same user marked message two times" do
			@message.notification.destroy
			@message.notification = nil
			lambda do
				@message.mark_to_delete(@user1)
				@message.mark_to_delete(@user1)
				@user1.outbox.should_not be_include(@message)
			end.should_not change(Message, :count)
		end
	end

	describe "validations for mark" do
		before(:each) do
			@user1 = FactoryGirl.create(:user)
			@user2 = FactoryGirl.create(:user,:email => FactoryGirl.generate(:email))
		end

		it "should not valid" do
			@message = FactoryGirl.build(:message, :user => @user1, 
				:target_user => @user2, :mark => @user1.id)
			@message.should_not be_valid 
		end

		it "should be valid" do
			@message = FactoryGirl.create(:message, :user => @user1, :target_user => @user2)
			@message.mark = @user1.id
			@message.should be_valid
		end
	end

end
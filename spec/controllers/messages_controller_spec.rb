require 'spec_helper'

describe MessagesController do
	
	before(:each) do
		@user1 = FactoryGirl.create(:user)
		@user2 = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
		@user3 = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
	end

	describe "show action" do

		before(:each) do
			@message = FactoryGirl.create(:message, :user => @user1, :target_user => @user2)
		end

		it "should be success" do
			sign_in(@user1)
			get :show, :id => @message.id
			response.should be_success
		end

		it "should be success" do
			sign_in(@user2)
			get :show, :id => @message.id
			response.should be_success
		end

		it "should be 404" do
			sign_in(@user3)
			get :show, :id => @message.id
			response.status.should be_equal(404)
		end

	end

	describe "mark_to_delete action" do

		before(:each) do
			@message = FactoryGirl.create(:message, :user => @user1, :target_user => @user2)
		end

		it "should redirect to user2 dialog" do
			sign_in(@user1)
			put :mark_to_delete, :id => @message.id
			response.should redirect_to dialog_user_path(@user2)
		end

		it "should redirect to user1 dialog" do
			sign_in(@user2)
			put :mark_to_delete, :id => @message.id
			response.should redirect_to dialog_user_path(@user1)
		end

		it "access denied for user3" do
			sign_in(@user3)
			put :mark_to_delete, :id => @message.id
			response.status.should be_equal(404)
		end

	end

end
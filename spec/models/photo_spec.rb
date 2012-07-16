require 'spec_helper'


describe Photo do
	before(:each) do
		@user1 = FactoryGirl.create(:user)
		@photo_album = FactoryGirl.create(:photo_album, :user => @user1)
		@user2 = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
		@photo = FactoryGirl.create(:photo, :user => @user1,
			 :photo_album => @photo_album)
	end
	describe "cant_like" do
		it "should be true" do
			@photo.cant_like?(@user1.id).should be_true
		end
		it "should be false" do
			Like.toggle_like(@photo.id,"Photo",@user1)
			@photo.cant_like?(@user1.id).should be_false
		end
	end
	describe "notify owner about like" do
		it "should not notify" do
			Like.toggle_like(@photo.id,"Photo",@user1)
			@photo.user.notifications.should be_empty
		end
		it "should notify" do
			Like.toggle_like(@photo.id,"Photo",@user2)
			@photo.user.notifications.should_not be_empty
		end
	end
	describe "notify owner about comment" do
		it "should not notify" do
			@comment = FactoryGirl.create(:comment, :user => @user1, :commentable => @photo)
			@photo.comments << @comment
			@photo.user.notifications.should be_empty
		end
		it "should notify" do
			@comment = FactoryGirl.create(:comment, :user => @user2, :commentable => @photo)
			@photo.comments << @comment
			@photo.user.notifications.should_not be_empty
		end
	end


end
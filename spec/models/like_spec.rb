require 'spec_helper'


describe Like do

	before(:each) do
		@user = FactoryGirl.create(:user)
		@post = FactoryGirl.create(:post, :user => @user, :target_user => @user)
	end

	describe "self.toggle_like" do
		it "should create like at post" do
			lambda do
				Like.toggle_like(@post.id,"Post",@user)
			end.should change(Like,:count).by(1)
		end

		it "should delete like" do
			Like.toggle_like(@post.id,"Post",@user)
			lambda do
				Like.toggle_like(@post.id,"Post",@user)
			end.should change(Like,:count).by(-1)
		end

		it "should raise exception" do
			lambda do
				Like.toggle_like(@post.id,"Comment",@user)
			end.should raise_error(ActiveRecord::RecordNotFound)
		end	

		it "should got false" do
			lambda do
				Like.toggle_like(@post.id,"tru-la-la",@user).should be_false
			end.should_not change(Like,:count)
		end	
	end



end
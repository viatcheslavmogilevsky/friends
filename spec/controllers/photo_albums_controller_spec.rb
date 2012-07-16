require "spec_helper"

describe PhotoAlbumsController do

	before(:each) do
			@user1 = FactoryGirl.create(:user)
			@user2 = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
	end

	describe "'GET' index" do
		
		it "should be success for each user" do
			sign_in(@user2)
			get :index, :user_id => @user1.id
			response.should be_success
		end
	end

	describe "'GET' show" do
		
		it "should be success for each user" do
			@photo_album = FactoryGirl.create(:photo_album, :user => @user1)
			sign_in(@user2)
			get :show, :user_id => @user1.id, :id => @photo_album.id
			response.should be_success
		end
	end


	describe "'POST' create" do

		it "should redirect to root for user2" do
			sign_in(@user2)
			post :create, :user_id => @user1.id,
			 :photo_album => FactoryGirl.attributes_for(:photo_album)
			response.should redirect_to(root_path)
		end

		it "should redirect to new photo album for user1" do
			sign_in(@user1)
			post :create, :user_id => @user1.id,
			 :photo_album => FactoryGirl.attributes_for(:photo_album) 
			response.should redirect_to(user_photo_album_path(@user1, @user1.photo_albums.last))
		end	
	end

	describe "'GET' new" do

		it "should redirect to root for user2" do
			sign_in(@user2)
			get :new, :user_id => @user1.id
			response.should redirect_to(root_path)
		end
		
		it "should be success for user1" do
			sign_in(@user1)
			get :new, :user_id => @user1.id
			response.should be_success
		end	
	end

	describe "'GET' edit" do

		before(:each) do
			@photo_album = FactoryGirl.create(:photo_album, :user => @user1)
		end

		it "should redirect to root for user2" do
			sign_in(@user2)
			get :edit, :user_id => @user1.id, :id => @photo_album.id
			response.should redirect_to(root_path)
		end
		
		it "should be success for user1" do
			sign_in(@user1)
			get :edit, :user_id => @user1.id, :id => @photo_album.id
			response.should be_success
		end	
	end

	describe "'PUT' update" do
		before(:each) do
			@photo_album = FactoryGirl.create(:photo_album, :user => @user1)
		end

		it "should redirect to root for user2" do
			sign_in(@user2)
			put :update, :user_id => @user1.id, :id => @photo_album.id
			response.should redirect_to(root_path) 
		end

		it "should be success for user1" do
			sign_in(@user1)
			put :update, :user_id => @user1.id, :id => @photo_album.id
			response.should redirect_to(user_photo_album_path(@user1,@photo_album))
		end
	end

	describe "'DELETE' destroy" do
		before(:each) do
			@photo_album = FactoryGirl.create(:photo_album, :user => @user1)
		end

		it "should redirect to root for user2" do
			sign_in(@user2)
			delete :destroy, :user_id => @user1.id, :id => @photo_album.id
			response.should redirect_to(root_path) 
		end

		it "should be success for user1" do
			sign_in(@user1)
			delete :destroy, :user_id => @user1.id, :id => @photo_album.id
			response.should redirect_to(user_photo_albums_path(@user1))
		end
	end
end
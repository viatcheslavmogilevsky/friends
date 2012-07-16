require "spec_helper"



describe PhotosController do

	before(:each) do
		@user1 = FactoryGirl.create(:user)
		@user2 = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
		@photo_album = FactoryGirl.create(:photo_album, :user => @user1)
	end

	describe "'GET' new" do
		it "should redirect to root for user2" do
			sign_in(@user2)
			get :new, :photo_album_id => @photo_album.id
			response.should redirect_to(root_path)
		end

		it "should be success for user1" do
			sign_in(@user1)
			get :new, :photo_album_id => @photo_album.id
			response.should be_success
		end
	end

	

	describe "'POST' create" do
		it "should redirect to root for user2" do
			sign_in(@user2)
			post :create, :photo_album_id => @photo_album.id, 
				:photo => {:content => fixture_file_upload("app/assets/images/rails.png","image/png")}
			response.should redirect_to(root_path)
		end

		it "should redirect to new photo for user1" do
			sign_in(@user1)
			post :create, :photo_album_id => @photo_album.id,
				:photo => {:content => fixture_file_upload("app/assets/images/rails.png","image/png")}
			response.should redirect_to(photo_path(@user1.photos.last))
		end
	end

	describe "'GET' edit" do
		before(:each) do
			@photo = FactoryGirl.create(:photo, :user => @user1,
			 :photo_album => @photo_album)
		end
		it "should redirect to root for user2" do
			sign_in(@user2)
			get :edit, :id => @photo.id
			response.should redirect_to(root_path)
		end

		it "should be success for user1" do
			sign_in(@user1)
			get :edit, :id => @photo.id
			response.should be_success
		end
	end

	describe "'PUT' update" do
		before(:each) do
			@photo = FactoryGirl.create(:photo, :user => @user1,
			 :photo_album => @photo_album)
		end
		it "should redirect to root for user2" do
			sign_in(@user2)
			put :update, :id => @photo.id, :photo => {:description => "abc"}
			response.should redirect_to(root_path)
		end
		it "should redirect to updated photo for user1" do
			sign_in(@user1)
			put :update, :id => @photo.id, :photo => {:description => "abc"}
			response.should redirect_to(@photo)
		end	
	end

	describe "'DELETE' destroy" do
		before(:each) do
			@photo = FactoryGirl.create(:photo, :user => @user1,
			 :photo_album => @photo_album)
		end
		it "should redirect to root for user2" do
			sign_in(@user2)
			delete :destroy, :id => @photo.id
			response.should redirect_to(root_path)
		end

		it "should redirect to updated photo for user1" do
			sign_in(@user1)
			delete :destroy, :id => @photo.id
			response.should redirect_to(user_photo_album_path(@user1,@photo_album))
		end	
	end
	

end
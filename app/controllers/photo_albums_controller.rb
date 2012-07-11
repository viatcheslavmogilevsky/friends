class PhotoAlbumsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :check_user, :except => [:show,:index]


	def index
		@user = User.find(params[:user_id])
		@photo_albums = @user.photo_albums
	end

	def show
		@photo_album = PhotoAlbum.find(params[:id])
		@photos = @photo_album.photos
	end

	def create
		@photo_album = @user.photo_albums.build(params[:photo_album])
		if @photo_album.save
			redirect_to user_photo_album_path(@user,@photo_album)
		else
			render 'form'
		end
	end

	def new
		@photo_album = @user.photo_albums.new 
		render 'form'
	end

	def edit
		@photo_album = PhotoAlbum.find(params[:id])
		render 'form'
	end

	def update
		@photo_album = PhotoAlbum.find(params[:id])
		if @photo_album.save?
			redirect_to user_photo_album_path(@user,@photo_album)
		else
			render 'form'
		end	
	end

	def destroy
		@photo_album = PhotoAlbum.find(params[:id])
		@photo_album.destroy
		redirect_to user_photo_albums_path(@user)
	end

	private

	def check_user
		@user = User.find(params[:user_id])
		redirect_to root_path if current_user != @user
	end
end

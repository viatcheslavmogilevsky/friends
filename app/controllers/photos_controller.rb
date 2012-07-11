class PhotosController < ApplicationController
	before_filter :authenticate_user!
	before_filter :check_album, :only => [:new,:create]
	before_filter :check_user, :only => [:edit,:update,:destroy]

	def new
		@photo = @photo_album.photos.new
		render 'form'		 
	end

	def create
		@photo = @photo_album.photos.build(params[:photo])
		if @photo.save
			redirect_to photo_path(@photo)
		else
			render 'form'
		end
	end

	def toggle_like
		Photo.like(params[:id],current_user.id)
		redirect_to photo_path(params[:id])
	end

	def edit
		render 'form'
	end

	def update
		if @photo.update_attributes(params[:photo])
			redirect_to photo_path(@photo)
		else
			render 'form'
		end
	end

	def index
		@user = User.find(params[:user_id])
		@photos = @user.photos
	end

	def show
		@parent = @photo = Photo.find(params[:id])
		@comments = @photo.comments.includes(:user) 
		@comment = current_user.comments.new
	end

	private

	def check_album
		@photo_album = PhotoAlbum.find(params[:photo_album_id])
		redirect_to root_path if current_user != @photo_album.user
	end

	def check_user
		@photo = Photo.find(params[:id])
		redirect_to root_path if current_user != @photo.user
	end
end

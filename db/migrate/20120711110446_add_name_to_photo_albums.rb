class AddNameToPhotoAlbums < ActiveRecord::Migration
  def change
    add_column :photo_albums, :name, :string
  end
end

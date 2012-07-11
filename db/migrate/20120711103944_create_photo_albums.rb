class CreatePhotoAlbums < ActiveRecord::Migration
  def change
    create_table :photo_albums do |t|
      t.integer :user_id
      t.text :description		

      t.timestamps
    end
  end
end

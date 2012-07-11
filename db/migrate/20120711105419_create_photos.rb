class CreatePhotos < ActiveRecord::Migration
  def up
  	create_table :photos do |t|
  		t.integer :photo_album_id
  		t.integer :user_id
  		t.text :description
  		t.has_attached_file :content
  	end
  end

  def down
  	drop_table :photos
  end
end

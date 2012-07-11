class AddPhotoToPosts < ActiveRecord::Migration
  def up
    change_table :posts do |t|
      t.has_attached_file :photo
    end
  end

  def down
    drop_attached_file :posts, :photo
  end
end

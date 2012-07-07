class CreateTrueFriendship < ActiveRecord::Migration
  def up
  	create_table :friendships, {id: false} do |t|
  		t.integer :user_id
  		t.integer :other_user_id
  	end
  	remove_column :user_friendships, :status
  end

  def down
  	drop_table :friendships
  	add_column :user_friendships, :status, :boolean
  end
end

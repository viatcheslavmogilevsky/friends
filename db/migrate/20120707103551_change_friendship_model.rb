class ChangeFriendshipModel < ActiveRecord::Migration
  def up
  	change_table :user_friendships, {id: true} do |t|
  		t.remove :created_at
  		t.remove :updated_at
  	end

  end

  def down
  end
end

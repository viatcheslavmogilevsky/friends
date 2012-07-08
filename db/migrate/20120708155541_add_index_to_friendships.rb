class AddIndexToFriendships < ActiveRecord::Migration
  def change
  	add_index :friendships, [:user_id,:other_user_id], :unique => true
  end
end

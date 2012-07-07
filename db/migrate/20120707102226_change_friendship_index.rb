class ChangeFriendshipIndex < ActiveRecord::Migration
  def up
  	rename_index :user_friendships, 'index friendships on ids', 'index_friendships_on_ids'
  end

  def down
  	rename_index :user_friendships, 'index_friendships_on_ids', 'index friendships on ids'
  end
end

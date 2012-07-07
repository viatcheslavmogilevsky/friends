class CreateUserFriendships < ActiveRecord::Migration
  def change
    create_table :user_friendships do |t|
      t.boolean :status, {default: false}
      t.integer :user_id
      t.integer :target_user_id

      t.timestamps
    end

    add_index :user_friendships, [:user_id,:target_user_id], 
    	{name: 'index friendships on ids',unique: true}
  end
end

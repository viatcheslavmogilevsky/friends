class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.integer :target_user_id
      t.text :content
      t.integer :mark

      t.timestamps
    end
  end
end

class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :target_user_id
      t.text :content
      t.references :commentable, :polymorphic => true

      t.timestamps
    end
  end
end

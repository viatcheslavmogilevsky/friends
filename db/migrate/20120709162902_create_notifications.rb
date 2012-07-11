class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :target_user_id
      t.references :notificable, :polymorphic => :true

      t.timestamps
    end
  end
end

class DeleteUpdatedFromSomeTables < ActiveRecord::Migration
  def up
  	remove_column :notifications, :updated_at
  	remove_column :comments, :updated_at
  end

  def down
  	add_column :notifications, :updated_at, :datetime
  	remove_column :comments, :updated_at, :datetime
  end
end

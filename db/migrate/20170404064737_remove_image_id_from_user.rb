class RemoveImageIdFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :image_id, :integer
  end
end

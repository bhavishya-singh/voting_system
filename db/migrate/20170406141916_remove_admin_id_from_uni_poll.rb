class RemoveAdminIdFromUniPoll < ActiveRecord::Migration
  def change
  	remove_column :uni_polls, :admin_id, :integer
  end
end

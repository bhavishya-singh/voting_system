class AddPollEndToGroupPoll < ActiveRecord::Migration
  def change
    add_column :group_polls, :poll_end, :boolean, :default => false
   
  end
end

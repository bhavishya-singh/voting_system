class AddDefaultValueToVotes < ActiveRecord::Migration
  def change
  	change_column :uni_poll_competitor_mappings ,:votes, :integer, :default => 0
  end
end

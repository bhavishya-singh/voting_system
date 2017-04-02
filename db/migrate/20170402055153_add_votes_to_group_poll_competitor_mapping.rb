class AddVotesToGroupPollCompetitorMapping < ActiveRecord::Migration
  def change
    add_column :group_poll_competitor_mappings, :votes, :integer, :default => 0
  end
end

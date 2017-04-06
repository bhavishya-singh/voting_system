class RemoveCompetitorIdFromUniPollCompetitorMapping < ActiveRecord::Migration
  def change
    remove_column :uni_poll_competitor_mappings, :competitor_id, :integer
  end
end

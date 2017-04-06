class AddColumnToUniPollCompetitorMapping < ActiveRecord::Migration
  def change
  	add_column :uni_poll_competitor_mappings ,:competitor_name, :string
  end
end

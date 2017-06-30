class AddtaglinetogroupPollCompetitorMappings < ActiveRecord::Migration
  def change
    add_column :group_poll_competitor_mappings, :contestant_tag_line, :string

  end
end

class AddTagLinetoUniPollCompetitorMappings < ActiveRecord::Migration
  def change
    add_column :uni_poll_competitor_mappings, :contestant_tag_line, :string
  end
end

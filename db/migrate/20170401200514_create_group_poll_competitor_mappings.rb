class CreateGroupPollCompetitorMappings < ActiveRecord::Migration
  def change
    create_table :group_poll_competitor_mappings do |t|
      t.integer :competitor_id, index: true, foreign_key: {to_table: :users}
      t.references :group_poll, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

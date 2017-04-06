class CreateUniPollCompetitorMappings < ActiveRecord::Migration
  def change
    create_table :uni_poll_competitor_mappings do |t|
      t.integer :competitor_id, index: true, foreign_key: {to_table: :users}
      t.references :uni_poll, index: true, foreign_key: true
      t.integer :votes

      t.timestamps null: false
    end
  end
end

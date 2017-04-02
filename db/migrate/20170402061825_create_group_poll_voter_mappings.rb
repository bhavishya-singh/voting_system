class CreateGroupPollVoterMappings < ActiveRecord::Migration
  def change
    create_table :group_poll_voter_mappings do |t|
      t.references :group_poll, index: true, foreign_key: true
      t.integer :voter_id, index: true, foreign_key: {to_table: :users}

      t.timestamps null: false
    end
  end
end

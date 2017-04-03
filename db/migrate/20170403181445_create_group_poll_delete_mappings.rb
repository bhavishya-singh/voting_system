class CreateGroupPollDeleteMappings < ActiveRecord::Migration
  def change
    create_table :group_poll_delete_mappings do |t|
      t.references :group_poll, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

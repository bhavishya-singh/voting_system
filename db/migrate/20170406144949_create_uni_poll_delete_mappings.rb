class CreateUniPollDeleteMappings < ActiveRecord::Migration
  def change
    create_table :uni_poll_delete_mappings do |t|
      t.references :uni_poll, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

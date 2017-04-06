class CreateUniPollAdminMappings < ActiveRecord::Migration
  def change
    create_table :uni_poll_admin_mappings do |t|
      t.integer :admin_id, index: true, foreign_key: {to_table: :users}
      t.references :uni_poll, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

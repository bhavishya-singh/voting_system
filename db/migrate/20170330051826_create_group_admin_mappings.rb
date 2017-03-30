class CreateGroupAdminMappings < ActiveRecord::Migration
  def change
    create_table :group_admin_mappings do |t|
      t.integer :admin_id, index: true, foreign_key: {to_table: :users}
      t.references :group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

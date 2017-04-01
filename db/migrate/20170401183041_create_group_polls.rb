class CreateGroupPolls < ActiveRecord::Migration
  def change
    create_table :group_polls do |t|
      t.string :name
      t.references :group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

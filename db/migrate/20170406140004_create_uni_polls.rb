class CreateUniPolls < ActiveRecord::Migration
  def change
    create_table :uni_polls do |t|
      t.string :name
      t.boolean :poll_end, :default => false
      t.integer :admin_id, index: true, foreign_key: {to_table: :users}

      t.timestamps null: false
    end
  end
end

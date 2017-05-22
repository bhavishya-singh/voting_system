class AddNotNullCountry < ActiveRecord::Migration
  def change
    change_column :users, :country, :string, null: false, default: "India"
  end
end

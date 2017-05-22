class RemoveCountryFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :country, :string, :null => false
  end
end

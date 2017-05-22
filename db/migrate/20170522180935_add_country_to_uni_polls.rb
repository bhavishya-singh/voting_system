class AddCountryToUniPolls < ActiveRecord::Migration
  def change
    add_column :uni_polls, :country, :string
  end
end

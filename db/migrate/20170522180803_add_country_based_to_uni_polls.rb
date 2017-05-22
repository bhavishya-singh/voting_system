class AddCountryBasedToUniPolls < ActiveRecord::Migration
  def change
    add_column :uni_polls, :country_based, :boolean
  end
end

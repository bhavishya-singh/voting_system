class AddStartDatetoGroupPolls < ActiveRecord::Migration
  def change
    add_column :group_polls, :start_date, :datetime
  end
end

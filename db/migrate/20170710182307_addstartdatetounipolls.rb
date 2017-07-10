class Addstartdatetounipolls < ActiveRecord::Migration
  def change
    add_column :uni_polls, :start_date,:datetime
  end
end

class Addpicturetounipollcontestants < ActiveRecord::Migration
  def change
    add_column :uni_poll_competitor_mappings, :contestant_picture, :string
  end
end

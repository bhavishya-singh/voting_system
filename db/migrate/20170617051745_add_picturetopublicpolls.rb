class AddPicturetopublicpolls < ActiveRecord::Migration
  def change
    add_column :uni_polls, :poll_picture, :string
  end
end

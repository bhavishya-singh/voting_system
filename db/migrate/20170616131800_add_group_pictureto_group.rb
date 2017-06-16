class AddGroupPicturetoGroup < ActiveRecord::Migration
  def change
    add_column :groups, :group_picture, :string
  end
end

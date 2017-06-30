class Addddefaultvaluetouserprofile < ActiveRecord::Migration
  def change
    change_column_default :users, :profile_picture, "user.png"
  end
end

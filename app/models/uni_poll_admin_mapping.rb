class UniPollAdminMapping < ActiveRecord::Base
  belongs_to :uni_poll
  belongs_to :admin, :class_name => "User", :foreign_key => "admin_id"
end

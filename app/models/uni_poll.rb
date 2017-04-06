class UniPoll < ActiveRecord::Base
	has_one :uni_poll_admin_mapping
	has_one :admin, :through => :uni_poll_admin_mapping
end

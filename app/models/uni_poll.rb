class UniPoll < ActiveRecord::Base
	has_one :uni_poll_admin_mapping
	has_one :admin, :through => :uni_poll_admin_mapping
	has_many :uni_poll_competitor_mappings
	has_many :uni_poll_voter_mappings
  	has_many :voters, :through => :uni_poll_voter_mappings
  	has_many :uni_poll_delete_mappings

end

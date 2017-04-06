class UniPollVoterMapping < ActiveRecord::Base
  belongs_to :uni_poll
  belongs_to :voter, :class_name => "User", :foreign_key => "voter_id"
end

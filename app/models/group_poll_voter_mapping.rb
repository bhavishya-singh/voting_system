class GroupPollVoterMapping < ActiveRecord::Base
  belongs_to :group_poll
  belongs_to :voter, class_name: 'User'
end

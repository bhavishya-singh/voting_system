class GroupPollCompetitorMapping < ActiveRecord::Base
  belongs_to :group_poll
  belongs_to :competitor, class_name: 'User'
end

class GroupPollDeleteMapping < ActiveRecord::Base
  belongs_to :group_poll
  belongs_to :user
end

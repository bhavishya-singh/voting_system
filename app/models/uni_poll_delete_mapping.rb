class UniPollDeleteMapping < ActiveRecord::Base
  belongs_to :uni_poll
  belongs_to :user
end

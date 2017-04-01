class GroupPoll < ActiveRecord::Base
  belongs_to :group
  
  has_many :group_poll_competitor_mappings
  has_many :competitors, :through => :group_poll_competitor_mappings


end

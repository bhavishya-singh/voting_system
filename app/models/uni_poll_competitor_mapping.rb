class UniPollCompetitorMapping < ActiveRecord::Base
  belongs_to :uni_poll
  belongs_to :competitor, :class_name => "User", :foreign_key => "competitor_id"
end

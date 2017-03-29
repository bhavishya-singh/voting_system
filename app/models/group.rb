class Group < ActiveRecord::Base
	after_initialize :set_no_users
	validates :name , :presence => true
	has_many :group_user_mappings
	has_many :users, :through => :group_user_mappings

	private 
	def set_no_users
		self.no_users ||= 0;
	end
end

class Group < ActiveRecord::Base
	after_initialize :set_no_users
	validates :name , :presence => true

	has_many :users, :through => :GroupUserMapping

	private 
	def set_no_users
		self.no_users ||= 0;
	end
end

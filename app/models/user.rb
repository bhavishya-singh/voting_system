class User < ActiveRecord::Base

	validates :user_name, :presence => true, :uniqueness => true


	has_many :group_user_mappings
	has_many :groups, :through => :group_user_mappings

	
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end

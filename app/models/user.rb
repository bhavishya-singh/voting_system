class User < ActiveRecord::Base

	validates :user_name, :presence => true, :uniqueness => true

  has_one :image

	has_many :group_user_mappings
	has_many :groups, :through => :group_user_mappings

	has_many :group_poll_competitor_mappings
    has_many :group_polls, :through => :group_poll_competitor_mappings

    has_many :group_poll_delete_mappings
    has_many :group_polls_deleted, :through => :group_poll_delete_mappings, :source => :group_poll
	
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end

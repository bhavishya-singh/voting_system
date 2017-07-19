class User < ActiveRecord::Base

  after_create :send_welcome_mail_async
	validates :user_name, :presence => true, :uniqueness => true

  has_one :image

	has_many :group_user_mappings
	has_many :groups, :through => :group_user_mappings

	has_many :group_poll_competitor_mappings
    has_many :group_polls, :through => :group_poll_competitor_mappings

    has_many :group_poll_delete_mappings
    has_many :group_polls_deleted, :through => :group_poll_delete_mappings, :source => :group_poll

    has_many :uni_poll_delete_mappings
    has_many :uni_polls_deleted, :through => :uni_poll_delete_mappings, :source => :uni_poll
	
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable ,:omniauthable, :omniauth_providers => [:facebook]

  def self.from_omniauth(auth)
    puts " ******** it has been here-------------------------------------"
    where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
      user.email = auth.info.email
      user.profile_picture = auth.info.image
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.create_instance(ses)
    if ses["info"]["email"]
      email = ses["info"]["email"]
    end
    first_name = ses["info"]["first_name"]
    last_name = ses["info"]["last_name"]
    profile_picture = ses["info"]["image"]
    provider = ses["provider"]
    uid = ses["uid"]
    User.new(:email => email, :first_name => first_name, :last_name => last_name, :profile_picture => profile_picture, :provider => provider, :uid => uid)
  end

  def self.new_with_session(params, session)
    puts "+++++++++++++++++++++++++++++++++++++++++++++++++ :) here tooo"
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def send_welcome_mail
    UserMailer.welcome_email(self).deliver_now
  end

  def send_welcome_mail_async
    Resque.enqueue(UserMailerWorker, self.id)
  end

end

class UserMailerWorker
  @queue = :user

  def self.perform user_id
    user = User.find(user_id)
    user.send_welcome_mail
  end
end
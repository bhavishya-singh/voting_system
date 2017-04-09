class UserMailer < ApplicationMailer

	default from: 'votemeindia@gmail.com'

	def welcome_email(user)
	    @user = user
	    @url  = 'http://localhost:3000/user_home'
	    mail(to: @user.email, subject: 'Welcome to My VoteMe')
	end
end

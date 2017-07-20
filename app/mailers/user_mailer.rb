class UserMailer < ApplicationMailer

	default from: 'votemeindia@gmail.com'

	def welcome_email(user)
	    @user = user
	    @url  = 'http://35.154.36.142/user_home'
	    mail(to: @user.email, subject: 'Welcome to VoteMe')
	end



end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :isUserAdmin?, :isuserAdminOfPublicPoll?


  def isUserAdmin? user, group
    # byebug
  	admins = group.admins
  	admins.each do |admin|

  		if admin.id === user.id
  			return true
  		end
  	end
  	return false
  end


  def isuserAdminOfPublicPoll? user, public_poll
    byebug
    admin = public_poll.admin
    if admin.id == user.id
      return true
    else 
      return false
    end
  end

end

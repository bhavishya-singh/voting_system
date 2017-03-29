class HomeController < ApplicationController
  
	before_action :authenticate_user! , :only => [:user_home]

  def index
  end

  def user_home
  	@user = current_user
  	@groups = current_user.groups
  	
  end

end

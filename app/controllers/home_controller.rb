class HomeController < ApplicationController
  
	before_action :authenticate_user! , :only => [:user_home, :user_json]

  def index
  end

  def user_home
  	@user = current_user
  	@groups = current_user.groups
  	
  end

  def user_json
  	@groups = current_user.groups
  	render :json => @groups.to_json(:only => [:id,:name])
  end

end

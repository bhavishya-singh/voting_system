class FacebookRegistrationsController < ApplicationController

  def new
    data = session["facebook_data"]
    @user = User.create_instance(data)

  end

  def create
    if User.where(:user_name => params[:user][:user_name]).first || User.where(:email => params[:user][:email]).first
      return redirect_to "/" ,:alert => "Sorry couldn't signUp, email or user_name has been taken"
    end
    user = User.create(:first_name => params[:user][:first_name], :last_name => params[:user][:last_name],:user_name => params[:user][:user_name], :provider => params[:user][:provider], :uid => params[:user][:uid], :profile_picture => params[:user][:profile_picture], :email => params[:user][:email], :country => params[:user][:country], :password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
    sign_in_and_redirect user
  end

end


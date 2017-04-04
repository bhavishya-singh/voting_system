class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super
    initialize_image resource

  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

protected

  def after_sign_up_path_for(resource)
      stored_location_for(resource) || :user_home
  end

  def initialize_image resource
    original_filename = params["user"]["image"].original_filename
    @image = Image.create(:filename => original_filename, :user_id => resource.id)

    file_name = resource.id.to_s + "_" + original_filename
    temp_file = params["user"]["image"]
    File.open(Rails.root.join('public', 'uploads', file_name), 'wb') do |file|
      file.write(temp_file.read)
    end

  end

  # If you have extra params to permit, append them to the sanitizer.
  def sign_up_params
    return params.require(:user).permit(:email, :password, :password_confirmation,:first_name, :last_name,:user_name)
  end

  # If you have extra params to permit, append them to the sanitizer.
  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :first_name, :last_name, :user_name)
  end
  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end

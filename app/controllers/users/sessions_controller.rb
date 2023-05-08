# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    user = warden.authenticate!(auth_options)
    token = Tiddle.create_and_return_token(user, request)
    render json: { authentication_token: token, isAdmin: user.admin?}
  end

  # DELETE /resource/sign_out
  def destroy
    Tiddle.expire_token(current_user, request) if current_user
    # Tiddle.purge_old_tokens(current_user.)
    render json: {}
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private
    def verify_signed_out_user
    end
end

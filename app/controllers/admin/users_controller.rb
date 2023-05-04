class Admin::UsersController < ApplicationController
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    authorize [:admin]
    @users = User.all
  end

  def destroy
    @user = User.find(params[:id])
    authorize [:admin]
    @user.destroy

    redirect_to admin_user_path, status: :see_other
  end

  def update
    @user = User.find(params[:id])
    authorize [:admin]
    @user.update(user_params)

    redirect_to admin_users_path
  end

  private
    def user_not_authorized(exception)
      flash[:warning] = "You are not authorized to perform this action."

      redirect_to(request.referrer || root_path)
    end

    def user_params
      params.require(:user).permit(:role)
    end
end

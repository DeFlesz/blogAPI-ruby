class Admin::UsersController < ApplicationController
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    authorize [:admin]
    @users = User.all
    render json: @users, status: 200
  end

  def show
    @user = User.find(params[:id])

    render json: @user, status: 200
  end

  def destroy
    @user = User.find(params[:id])
    authorize [:admin]
    @user.destroy

    render json: {message: "user destroyed!"}, status: :see_other
  end

  def update
    @user = User.find(params[:id])
    authorize [:admin]
    @user.update(user_params)

    render json: {message: "user successfully updated!"}, status: 200
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

class Admin::UsersController < ApplicationController
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    authorize [:admin]
    page = params[:page] || 1
    @users = User.page(page).per(10)


    users_count = User.count
    pages_count = users_count % 10 == 0 ? users_count / 10 : users_count / 10 + 1

    render json: {users: @users.as_json, pages_count: pages_count}, status: 200
  end

  def show
    authorize [:admin]
    @user = User.find(params[:id])

    render json: @user.as_json, status: 200
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

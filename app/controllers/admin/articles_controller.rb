class Admin::ArticlesController < ApplicationController
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    authorize [:admin]

    @articles = Article.all
    if (params[:user_id] == nil)
      return
    end
    @user = User.find(params[:user_id])
    @articles = @user.articles

    render json: @articles, status: 200
  end

  private
    def article_params
      params.require(:article).permit(:title, :body, :status, :user_id)
    end

    def user_not_authorized(exception)
      flash[:warning] = "You are not authorized to perform this action."

      redirect_to(request.referrer || root_path)
    end
end

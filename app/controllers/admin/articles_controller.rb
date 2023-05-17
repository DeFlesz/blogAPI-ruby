class Admin::ArticlesController < ApplicationController
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    # @articles = Article.all
    page = params[:page] || 1
    @articles = Article.page(page).per(10)
    if (params[:user_id] == nil)
      return
    end

    @user = User.find(params[:user_id])
    @articles = @user.articles.page(page).per(10)

    articles_count = @user.articles.count
    pages_count = articles_count % 10 == 0 ? articles_count / 10 : articles_count / 10 + 1
    authorize @articles

    render json: {articles: @articles.as_json, pages_count: pages_count.to_i}, status: 200
  end

  private
    def article_params
      params.require(:article).permit(:title, :body, :status, :user_id)
    end

    def user_not_authorized(exception)
      render json: {message: "You are not authorized to perform this action."}, status: 403
    end
end

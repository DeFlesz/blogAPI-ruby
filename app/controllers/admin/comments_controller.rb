class Admin::CommentsController < ApplicationController
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    authorize [:admin]
    @user = User.find(params[:user_id])
    @article = @user.articles.find(params[:article_id])

    page = params[:page] || 1
    @comments = @article.comments.page(page).per(5)
    comments_count = @article.comments.count
    pages_count = comments_count % 5 == 0 ? comments_count / 5 : comments_count / 5 + 1

    render json: { comments: @comments.as_json, pages_count: pages_count }, status: 200
  end

  private
    def user_not_authorized(exception)
      render json: {message: "You are not authorized to perform this action."}, status: 403
    end
end

class CommentsController < ApplicationController
  include Pundit::Authorization

  def index
    @article = Article.find(params[:article_id])

    page = params[:page] || 1
    @comments = @article.comments.page(page).per(10)
    pages_count = @article.comments.count / 10 + 1

    authorize @comments

    render json: { comments: @comments.as_json, pages_count: pages_count }, status: 200
  end

  def create
    @article = Article.find(params[:article_id])
    @comment = Comment.new(comment_params)
    @comment.article = @article
    @comment.user = current_user

    authorize @comment

    if @comment.save
      render json: { message: "succesfully posted a comment!" }, status: 200
    else
      render json: { message: "couldn't post a comment!" }, status: 304
    end

    # redirect_to article_path(@article)
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    authorize @comment
    @comment.destroy


    redirect_to article_path(@article), status: :see_other
  end

  private
    def comment_params
      params.require(:comment).permit(:body, :status, :user_id)
    end
end

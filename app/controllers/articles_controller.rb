class ArticlesController < ApplicationController
  include Pundit::Authorization

  def index
    page = params[:page] || 1
    @articles = Article.page(page).per(10)
    authorize @articles
    articles_count = Article.count
    pages_count = articles_count % 10 == 0 ? articles_count / 10 : articles_count / 10 + 1

    render json: {articles: @articles.as_json, pages_count: pages_count.to_i}, status: 200
  end

  def show
    @article = Article.find(params[:id])
    authorize @article

    render json: @article.as_json, status: 200
  end

  def new
    @article = Article.new
    authorize @article
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    authorize @article

    if @article.save
      render json: {message: "article created successfully!"}, status: 200
    else
      render json: {message: "failed when saving article!"}, status: 304
    end
  end

  def edit
    @article = Article.find(params[:id])
    authorize @article
  end

  def update
    @article = Article.find(params[:id])
    authorize @article

    if @article.update(article_params)
      render json: {message: "article changed successfully!"}, status: 200
    else
      render json: {message: "failed when saving article!"}, status: 304
    end
  end

  def destroy
    @article = Article.find(params[:id])
    authorize @article

    @article.destroy

    redirect_to root_path, status: :see_other
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
    def article_params
      params.require(:article).permit(:title, :body, :status, :user_id)
    end

    def user_not_authorized(exception)
      render json: {message: "You are not authorized to perform this action."}, status: 403
    end
end

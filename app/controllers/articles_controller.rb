class ArticlesController < ApplicationController
  include Pundit::Authorization

  def index
    @articles = Article.all
    authorize @articles

    render json: @articles, status: 200
  end

  def show
    @article = Article.find(params[:id])
    authorize @article

    render json: @article, status: 200
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
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
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
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
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
      flash[:warning] = "You are not authorized to perform this action."

      redirect_to(request.referrer || root_path)
    end
end

class PdfgenJob
  include Sidekiq::Job

  def perform(article_id)
    article = Article.find(article_id)
    comments = article.comments
    user = article.user
    render json: { user: user, article: article, comments: comments }, status: 200
    # Do something
  end
end

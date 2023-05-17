class PdfgenJob
  include Sidekiq::Job

  def perform(t, id = -1)
    ActionCable.server.broadcast("pdf_gen_channel", { body: "job started"})
    newJobItem = PdfJobItem.create(t: t, filepath: nil, status: "inprogress", ref: id )

    case t
    when 'article'
      if Article.exists?(id)
        content = Article.find(id)
        pdf_html = ActionController::Base.new.render_to_string(template: 'articles/show', layout: 'pdf', locals: { article: content})
      else
        pdf_html = ActionController::Base.new.render_to_string(template: 'articles/not_found', layout: 'pdf', locals: { id: id})
      end
    when 'articles'
      content = Article.all
      pdf_html = ActionController::Base.new.render_to_string(template: 'articles/index', layout: 'pdf', locals: { articles: content})
    else
      content = User.all
      pdf_html = ActionController::Base.new.render_to_string(template: 'users/index', layout: 'pdf', locals: { users: content})
    end

    # pdf = WickedPdf.new.pdf_from_string(content.as_json.to_s)
    pdf = WickedPdf.new.pdf_from_string(pdf_html)
    save_path = Rails.root.join('pdfs',"#{newJobItem.t == 'article' && Article.exists?(id) ? content.title : newJobItem.t}-#{newJobItem.created_at.to_s}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end

    # in order to simulate slow gen
    # sleep 10

    newJobItem.status = "finished"
    newJobItem.filepath = save_path
    newJobItem.save
    # article = Article.find(article_id)
    # comments = article.comments
    # user = article.user
    # render json: { user: user, article: article, comments: comments }, status: 200
    # Do something
    ActionCable.server.broadcast("pdf_gen_channel", { body: "job finished"})
  end
end

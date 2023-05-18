class PdfgenJob
  include Sidekiq::Job

  def perform(job_id)
    ActionCable.server.broadcast("pdf_gen_channel", { body: "job started"})
    if PdfJobItem.exists?(job_id)
      newJobItem = PdfJobItem.find(job_id)
    else
      return
    end
    # liter
    case newJobItem.t
    when 'article'
      if Article.exists?(newJobItem.ref)
        content = Article.find(newJobItem.ref)
        title = 'article'
        pdf_html = ActionController::Base.new.render_to_string(
          template: 'articles/show',
          layout: 'pdf',
          locals: {
            article: content
          },
          # header: { right: '[page] of [topage]' }
          # header: {
          #   html: { template: '/layouts/_header.html'}
          # },
          # footer: {
          #   html: { template: '/layouts/_footer.html'}
          # }
        )
      else
        title = 'not found'
        pdf_html = ActionController::Base.new.render_to_string(
          template: 'articles/not_found',
          layout: 'pdf',
          locals: { id: newJobItem.ref }
        )
      end
    when 'articles'
      content = Article.all
      title = 'articles'
      pdf_html = ActionController::Base.new.render_to_string(
        template: 'articles/index',
        layout: 'pdf',
        locals: { articles: content }
      )
    else
      content = User.all
      title = 'users'
      pdf_html = ActionController::Base.new.render_to_string(template: 'users/index', layout: 'pdf', locals: { users: content })
    end

    # pdf = WickedPdf.new.pdf_from_string(content.as_json.to_s)
    pdf = WickedPdf.new.pdf_from_string(pdf_html,
      encoding: "utf-8",
      # viewport_size: "1024x768",
      # footer: { center: '[page] of [topage]', left: 'pages:' },
      # header: { center: title }
      header: {
        content: ActionController::Base.new.render_to_string( template: 'shared/header', layout: nil, locals: {title: title} )
        # html: { template: 'shared/header.html', layout: nil, locals: {title: title} }
      },
      footer: {
        content: ActionController::Base.new.render_to_string( template: 'shared/footer', layout: nil )

        # html: { template: 'shared/footer.html', layout: nil }
      }
    )
    save_path = Rails.root.join('pdfs',"#{newJobItem.t == 'article' && Article.exists?(newJobItem.ref) ? content.title : newJobItem.t}-#{newJobItem.created_at.to_s}.pdf")
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

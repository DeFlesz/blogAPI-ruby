class Pdf::PdfJobItemsController < ApplicationController
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    authorize [:admin]

    page = params[:page] || 1
    @jobs = PdfJobItem.order('created_at DESC').page(page).per(10)
    jobs_count = PdfJobItem.count
    pages_count = jobs_count % 10 == 0 ? jobs_count / 10 : jobs_count / 10 + 1

    render json: {pdf_job_items: @jobs.as_json, pages_count: pages_count.to_i}, status: 200
  end

  def show
    authorize [:admin]

    if PdfJobItem.exists?(params[:id])
      @job = PdfJobItem.find(params[:id])
      if @job.status == 'finished'
        # save_path = Rails.root.join('pdfs',"#{@job.t == 'article' ? Article.find(@job.ref).title : @job.t}-#{@job.created_at.to_s}.pdf")

        send_file(@job.filepath, filename: "#{@job.t}.pdf", type: 'application/pdf')
      else
        render json: { message: "The file is still processing!"}, status: 404
      end
    else
      render json: { message: "Couldn't find a matching file!"}, status: 404
    end
  end

  def destroy
    authorize [:admin]

    @job = PdfJobItem.find(params[:id])
    if @job.filepath && File.file?(@job.filepath)
      File.delete(@job.filepath)
    end

    @job.destroy
    render json: { message: "item successfully deleted"}, status: :see_other
  end

  private
    def user_not_authorized(exception)
      render json: {message: "You are not authorized to perform this action."}, status: 403
    end
end

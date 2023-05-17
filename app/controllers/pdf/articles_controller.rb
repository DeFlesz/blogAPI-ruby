class Pdf::ArticlesController < ApplicationController
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    authorize [:admin]
    PdfgenJob.perform_async('articles')

    render json: { message: 'received' }, status: 200
  end

  def show
    authorize [:admin]
    PdfgenJob.perform_async('article', params[:id])

    render json: { message: 'received' }, status: 200
  end

  private
    def user_not_authorized(exception)
      render json: {message: "You are not authorized to perform this action."}, status: 403
    end
end

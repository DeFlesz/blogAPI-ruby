class Pdf::ArticlesController < ApplicationController
  def show
    PdfgenJob.perform_async(params[:id])

    render json: { message: 'received' }, status: 200
  end
end

class Pdf::UsersController < ApplicationController
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    authorize [:admin]
    newJobItem = PdfJobItem.create(t: 'users', filepath: nil, status: "inprogress", ref: -1 )
    PdfgenJob.perform_async(newJobItem.id)

    render json: { message: 'received' }, status: 200
  end

  private
    def user_not_authorized(exception)
      render json: {message: "You are not authorized to perform this action."}, status: 403
    end
end

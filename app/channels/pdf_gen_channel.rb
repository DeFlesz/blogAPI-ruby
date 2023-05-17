
class PdfGenChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'pdf_gen_channel'
  end

  def unsubscribed
    # cleanup
  end
end

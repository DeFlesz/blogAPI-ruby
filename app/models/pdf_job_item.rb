class PdfJobItem < ApplicationRecord
  def as_json
    jsn = {
      id: id,
      t: t,
      filepath: filepath,
      status: status,
      datetime: created_at,
      title: ref > 0 && Article.exists?(ref) ? Article.find(ref).title : nil
    }
    jsn
  end
end

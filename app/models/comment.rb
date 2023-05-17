class Comment < ApplicationRecord
  include Visible

  belongs_to :article
  belongs_to :user

  # validates :commenter, presence: false
  validates :body, presence: true, length: {minimum: 3, maximum: 1000}
  def as_json
    jsn = {
      id: id,
      body: body,
      status: status,
      user_id: user_id,
      username: User.find(user_id).displayname
    }
    jsn
  end
end

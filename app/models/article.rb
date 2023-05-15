class Article < ApplicationRecord
  include Visible

  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: {minimum: 3, maximum: 128}
  validates :body, presence: true, length: {minimum: 10}

  def as_json
    jsn = {
      id: id,
      title: title,
      body: body,
      status: status,
      user_id: user_id,
      username: User.find(user_id).displayname
    }
    jsn
  end
end

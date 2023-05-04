class Comment < ApplicationRecord
  include Visible

  belongs_to :article
  belongs_to :user

  # validates :commenter, presence: false
  validates :body, presence: true, length: {minimum: 3}
end

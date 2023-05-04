class Article < ApplicationRecord
  include Visible

  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: {minimum: 3, maximum: 128}
  validates :body, presence: true, length: {minimum: 10}
end

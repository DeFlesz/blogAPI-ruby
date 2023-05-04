class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum role: {
    client: 0,
    admin: 1
  }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :articles, dependent: :destroy
  validates :displayname, presence: true, length: {minimum: 3, maximum: 32}
  def admin?
    self.role == "admin"
  end
end

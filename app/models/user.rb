class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  validates :username, presence: true, uniqueness: true

  enum role: { normal: 0, agency: 1 }

  def normal?
    role == "normal"
  end

  def agency?
    role == "agency"
  end
end

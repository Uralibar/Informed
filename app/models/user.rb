class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :active_follows, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :followees, through: :active_follows, source: :followee
  has_many :passive_follows, class_name: "Follow", foreign_key: "followee_id", dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower
  has_one_attached :profile_picture
  has_one_attached :banner
  validates :username, presence: true, uniqueness: true
  validates :biography, length: { maximum: 1000 }

  enum role: { normal: 0, agency: 1 }

  def normal?
    role == "normal"
  end

  def agency?
    role == "agency"
  end
end

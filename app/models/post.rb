class Post < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_rich_text :content
  has_many_attached :images
end

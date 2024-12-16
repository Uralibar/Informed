class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :user_id, uniqueness: { scope: :post_id, message: "can only vote once per post" }
  validates :value, inclusion: { in: [ -1, 1 ], message: "must be either -1 or 1" }
end

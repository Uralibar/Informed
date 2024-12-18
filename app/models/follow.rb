class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followee, class_name: "User"

  validate :followee_must_be_agency

  private

  def followee_must_be_agency
    errors.add(:followee, "must be an agency") unless followee.agency?
  end
end

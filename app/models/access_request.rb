class AccessRequest < ApplicationRecord
  belongs_to :user
  belongs_to :study

  validates :motivation, presence: true, length: { minimum: 20, maximum: 100 }
  validates :user_id, presence: true
  validates :study_id, presence: true
end

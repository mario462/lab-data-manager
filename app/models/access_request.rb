class AccessRequest < ApplicationRecord
  belongs_to :user
  belongs_to :study
  after_create :access_request_created_email
  after_update :status_changed_email

  validates :motivation, presence: true, length: { minimum: 20, maximum: 100 }
  validates :user_id, presence: true
  validates :study_id, presence: true
  validate :check_uniqueness

  def access_request_created_email
    UserMailer.new_access_request_email(self).deliver_later
  end

  def status_changed_email
    if self.saved_change_to_attribute?(:status) && !(self.status == AccessRequestStatus::PENDING)
      UserMailer.access_request_changed_email(self).deliver_later
    end
  end

  def check_uniqueness
    unique = AccessRequest.where(user: self.user, study: self.study).empty?
    errors.add(:uniqueness, 'You already have an access request for that study') unless unique
  end
end

class Permission < ApplicationRecord
  belongs_to :user
  belongs_to :study
  after_create :send_study_created_email

  def send_study_created_email
    if study.permissions.count <= 1
      UserMailer.study_created_email(self.user, self.study).deliver_later
    end
  end
end

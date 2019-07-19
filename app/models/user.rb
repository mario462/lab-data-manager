class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  after_create :send_user_registered_email
  after_update :check_user_approved
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :permissions, dependent: :delete_all
  has_many :studies, through: :permissions
  has_many :favorite_studies
  has_many :favorites, through: :favorite_studies, source: :study
  has_many :access_requests
  has_many :access_requested_for, through: :access_requests, source: :study

  validates :registration_reason, presence: true, length: { minimum: 20 }
  
  def available_studies
    studies = Study.all
    unless self.admin
      studies = studies.reject do |s|
        (s.visibility == Visibility::PRIVATE_ACCESS || s.pending) && !(s.in? self.studies)
      end
    end
    studies
  end

  def available_datasets
    datasets = Dataset.where("study_id IN (?)", self.available_studies.pluck(:id))
    unless self.admin
      datasets = datasets.reject do |d|
        d.pending && !self.owner?(d.study)
      end
    end
    datasets
  end

  def owned_studies
    Permission.where('user_id = ? AND access >= ?', self.id, Access::DESTROY).collect(&:study)
  end

  def can_read?(study)
    (!study.pending && study.visibility == Visibility::OPEN_USE) || (study.in? self.studies)
  end
  def can_edit?(study)
    permission = self.permissions.where(study: study).first
    permission.nil? ? false : (permission.access >= Access::EDIT)
  end
  def owner?(study)
    permission = self.permissions.where(study: study).first
    permission.nil? ? false : (permission.access >= Access::DESTROY)
  end

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end

  def send_user_registered_email
    UserMailer.welcome_user_email(self).deliver_later
    UserMailer.user_needs_approval_email(self).deliver_later
  end

  def check_user_approved
    if self.saved_change_to_attribute?(:approved) && self.approved
      UserMailer.user_approved_email(self).deliver_later
      UserMailer.user_approved_admins_email(self).deliver_later
    end
  end
end

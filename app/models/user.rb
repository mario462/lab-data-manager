class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :permissions, dependent: :delete_all
  has_many :studies, through: :permissions
  has_many :favorite_studies
  has_many :favorites, through: :favorite_studies, source: :study
  has_many :access_requests
  has_many :access_requested_for, through: :access_requests, source: :study

  def available_studies
    Study.all.reject do |s|
      s.visibility == Visibility::PRIVATE_ACCESS && !(s.in? self.studies)
    end
  end

  def owned_studies
    Permission.where('user_id = ? AND access >= ?', self.id, Access::DESTROY).collect(&:study)
  end

  def can_read?(study)
    study.visibility == Visibility::OPEN_USE || (study.in? self.studies)
  end
  def can_edit?(study)
    permission = self.permissions.where(study: study).first
    permission.nil? ? false : (permission.access >= Access::EDIT)
  end
  def owner?(study)
    permission = self.permissions.where(study: study).first
    permission.nil? ? false : (permission.access >= Access::DESTROY)
  end
end

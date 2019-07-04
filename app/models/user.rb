class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :permissions
  has_many :studies, through: :permissions

  def available_studies
    Study.all.reject do |s|
      s.visibility == Visibility::PRIVATE_ACCESS && !(s.in? self.studies)
    end
  end
end

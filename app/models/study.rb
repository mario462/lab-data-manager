class Study < ApplicationRecord
  include Visibility
  has_many :datasets, dependent: :delete_all
  has_many :permissions, dependent: :delete_all
  has_many :users, through: :permissions
  has_many :favorite_studies
  has_many :favorited_by, through: :favorite_studies, source: :user

  validates :name, :presence => true, :length => { :minimum => 5, :maximum => 50}
  validates :description, :length => { :minimum => 10 }
  validates :visibility, :presence => true
  validates :url, :allow_blank => true, :format => { :with => /https?:\/\/[\S]+/, :message => "Must be a valid full URL." }

  def datatypes
    self.datasets.map(&:datatype)
  end
end

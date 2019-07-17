class Dataset < ApplicationRecord
  belongs_to :study
  has_many :data_type
  attr_accessor :data_type_id
  mount_uploader :attachment, FileUploader
  mount_uploader :data, FileUploader

  validates :name, presence: true,
            length: {
                minimum: 5, maximum: 50
            }
  validates :description,
            length: {
                minimum: 10
            }
  validates :url, allow_blank: true,
            format: {
                with: /https?:\/\/[\S]+/, message: 'must be a valid full URL.'
            }
  validates :year, presence: true,
            inclusion: {
                in: 1900..Date.today.year
            },
            format: {
                with: /(19|20)\d{2}/i, message: 'should be a valid four-digit year.'
            }
  validates :number_subjects, presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }
  validates :data_type_ids,
            length: {
                minimum: 1, message: 'you must select at least one.'
            }

  def print_data_types
    self.data_type.map(&:name).join(', ')
  end

  def self.approved
    Dataset.where('pending != ?', true)
  end

  def self.pending
    Dataset.where('pending == ?', true)
  end

  def self.public
    self.approved.reject { |s| s.visibility == Visibility::PRIVATE_ACCESS }
  end
end

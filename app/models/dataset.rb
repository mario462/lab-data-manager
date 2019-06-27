class Dataset < ApplicationRecord
  belongs_to :study
  has_one :data_type
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
                with: /https?:\/\/[\S]+/, message: "Must be a valid full URL."
            }
  validates :year, presence: true,
            inclusion: {
                in: 1900..Date.today.year
            },
            format: {
                with: /(19|20)\d{2}/i, message: "Should be a four-digit year"
            }
  validates :number_subjects, presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }
end

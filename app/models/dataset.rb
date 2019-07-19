class Dataset < ApplicationRecord
  belongs_to :study
  has_many :data_type
  after_create :send_dataset_created_email
  after_update :check_dataset_approved
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

  def visibility
    self.study.pending ? Visibility::PRIVATE_ACCESS : self.study.visibility
  end

  def has_data?
    !(self.data.nil? || self.data.path.nil?)
  end

  def has_attachment?
    !(self.attachment.nil? || self.attachment.path.nil?)
  end

  def self.create_from_study(study)
    Dataset.new(name: study.name, description: study.description, study_id: study.id, year: 0, number_subjects: 0)
  end

  def send_dataset_created_email
    UserMailer.dataset_created_email(self).deliver_later
  end

  def check_dataset_approved
    if self.saved_change_to_attribute?(:pending) && !self.pending
      UserMailer.dataset_approved_email(self).deliver_later
    end
  end
end

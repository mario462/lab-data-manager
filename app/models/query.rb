class Query
  include ActiveModel::Model

  attr_accessor :text_query
  attr_accessor :data_types
  attr_accessor :selected_data_types
  attr_accessor :min_year
  attr_accessor :max_year
  attr_accessor :min_subjects
  attr_accessor :max_subjects
  attr_accessor :required_data
  attr_accessor :required_attachment

  validates :min_year, :max_year, :min_subjects, :max_subjects, numericality: { only_integer: true }
  validate :correct_boundaries

  def initialize(text_query: "", data_types: DataType.all, selected_data_types: [], min_year: 0, max_year: Date.today.year, min_subjects: 0,
                 max_subjects: max_number_subjects, required_data: false, required_attachment: false)
    self.text_query = text_query
    self.data_types = data_types
    self.selected_data_types = selected_data_types
    self.min_year = min_year
    self.max_year = max_year
    self.min_subjects = min_subjects
    self.max_subjects = max_subjects
    self.required_data = required_data
    self.required_attachment = required_attachment
  end

  private

  def max_number_subjects
    dataset = Dataset.order('number_subjects DESC').first
    dataset.nil? ? 0 : dataset.number_subjects
  end

  def correct_boundaries
    if self.min_year > self.max_year
      errors.add(:years_filter, 'wrong, maximum must be greater than minimum')
    end
    if self.min_subjects > self.max_subjects
      errors.add(:subjects_filter, 'wrong, maximum must be greater than minimum')
    end
  end
end

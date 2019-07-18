module FilterHelper
  def self.filter_text(array, text_query)
    array.select { |element| element.name.downcase.include?(text_query) || element.description.downcase.include?(text_query) }
  end

  def self.filter_numeric_fields(datasets, query)
    datasets.select do |dataset|
      dataset.year >= query.min_year && dataset.year <= query.max_year &&
          dataset.number_subjects >= query.min_subjects && dataset.number_subjects <= query.max_subjects
    end
  end

  def self.filter_datatypes(datasets, query)
    datasets.select do |dataset|
      data_types = dataset.data_type.map(&:id)
      selected = query.selected_data_types.map { |dt| dt.to_i }
      (data_types | selected) == data_types
    end
  end

  def self.filter_datasets(datasets, query)
    datasets = filter_text(datasets, query.text_query)
    datasets = filter_numeric_fields(datasets, query)
    if query.required_data
      datasets = datasets.select { |d| d.has_data? }
    end
    if query.required_attachment
      datasets = datasets.select { |d| d.has_attachment? }
    end
    datasets = filter_datatypes(datasets, query)
    datasets.map(&:study)
  end
end
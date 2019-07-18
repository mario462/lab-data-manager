module FilterHelper
  def self.filter_for_search(array, query)
    query ||= ''
    array.select { |element| element.name.downcase.include?(query) || element.description.downcase.include?(query) }
  end
end
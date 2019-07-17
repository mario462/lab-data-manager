class Card
  attr_accessor :title
  attr_accessor :subtitle

  def initialize(title, subtitle)
    @title = title
    @subtitle = subtitle
  end

  def self.get_home_cards
    cards = []
    cards << Card.new(Study.public.count, 'Studies')
    datasets = Dataset.public
    cards << Card.new(datasets.count, 'Datasets')
    cards << Card.new(datasets.reduce(0) { |sum, dataset| sum + dataset.number_subjects }, 'Subjects')
    cards << Card.new(datasets.reduce(0) { |sum, dataset| sum + dataset.downloads }, 'Downloads')
    cards
  end
end

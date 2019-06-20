class Study < ApplicationRecord
  include Visibility
  has_many :datasets

  def datatypes
    self.datasets.map(&:datatype)
  end
end

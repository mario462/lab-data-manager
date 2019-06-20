class Dataset < ApplicationRecord
  belongs_to :study
  has_one :data_type
end

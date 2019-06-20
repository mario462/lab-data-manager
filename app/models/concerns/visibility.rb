module Visibility
  extend ActiveSupport::Concern
  included do
    enum Visibility: [:Private, :Protected, :Public]
  end
end

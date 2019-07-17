module PublicVisible
  extend ActiveSupport::Concern
  included do
    def self.approved
      self.class.where('pending != ?', true)
    end

    def self.pending
      self.class.where('pending == ?', true)
    end

    def self.public
      self.approved.reject { |s| s.visibility == Visibility::PRIVATE_ACCESS }
    end
  end
end

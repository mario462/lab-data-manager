module Visibility
  extend ActiveSupport::Concern
    PRIVATE_ACCESS = "private_access"
    APPLY_ACCESS = "apply_access"
    OPEN_USE = "open_use"

    included do
      enum visibility: {
          Visibility::PRIVATE_ACCESS => "Private",
          Visibility::APPLY_ACCESS => "Apply for Access",
          Visibility::OPEN_USE => "Open Use"
      }

    def visibility_as_string
      self.class.visibilities[self.visibility]
    end
  end
end

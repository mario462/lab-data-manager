module Visibility
  extend ActiveSupport::Concern
  included do
    enum visibility: {
        private_access: "Private",
        apply_access: "Apply for Access",
        open_use: "Open Use"
    }

    def visibility_as_string
      self.class.visibilities[self.visibility]
    end
  end
end

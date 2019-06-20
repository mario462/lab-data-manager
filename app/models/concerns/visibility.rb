module Visibility
  extend ActiveSupport::Concern
  included do
    enum visibility: {
        private_access: "Private",
        apply_access: "Apply for Access",
        open_use: "Open Use"
    }
  end
end

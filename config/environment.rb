# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
LabManager::Application.default_url_options = LabManager::Application.config.action_mailer.default_url_options
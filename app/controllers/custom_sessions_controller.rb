class CustomSessionsController < Devise::SessionsController
  skip_authorization_check
end
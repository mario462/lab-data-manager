RailsAdmin.config do |config|
  config.authorize_with do
    redirect_to main_app.root_path, alert: 'You are not authorized to access this page.' unless current_user&.admin
  end
  config.label_methods << :email
  config.model 'FavoriteStudy' do
    object_label_method do
      :favorite_study_label
    end
  end
  config.model 'Permission' do
    object_label_method do
      :permission_label
    end
    list do
      include_all_fields
      field :access do
        formatted_value do # used in form views
          Access::access_to_string(value)
        end
      end
    end
  end

  def favorite_study_label
    self.study.name
  end
  def permission_label
    Access::access_to_string(self.access)
  end
  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end

class RegistrationsController < Devise::RegistrationsController
  def create
    super do
      resource.registration_reason = registration_params[:registration_reason]
      resource.save
    end
  end

  private

  def registration_params
    params.require(:user).permit(:registration_reason)
  end
end
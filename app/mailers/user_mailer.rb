class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'
  SITE_NAME = ENV['site_name']

  def welcome_user_email(user)
    @user = user
    @site_name = SITE_NAME
    mail(template_name: 'welcome_user_email', to: @user.email, subject: "Welcome to #{@site_name}")
  end

  def user_needs_approval_email(user)
    @user = user
    @url = rails_admin.edit_url(model_name: 'user', id: @user.id)
    mail(template_name: 'user_needs_approval_email', to: admin_emails, subject: "[#{SITE_NAME}] User account needs approval")
  end

  private

  def admin_emails
    User.where(admin: true).pluck(:email)
  end
end

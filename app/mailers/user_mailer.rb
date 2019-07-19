class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'
  SITE_NAME = ENV['site_name']

  def welcome_user_email(user)
    @user = user
    @site_name = SITE_NAME
    mail(to: @user.email, subject: "Welcome to #{@site_name}")
  end

  def user_needs_approval_email(user)
    @user = user
    @url = rails_admin.edit_url(model_name: 'user', id: @user.id)
    mail(to: admin_emails, subject: "[#{SITE_NAME}] User account needs approval")
  end

  def user_approved_email(user)
    @site_name = SITE_NAME
    @url = new_user_session_url
    mail(to: user.email, subject: "[#{@site_name}] Your account has been approved!")
  end

  def user_approved_admins_email(user)
    @user = user
    mail(to: admin_emails, subject: "[#{SITE_NAME}] User account has been approved")
  end

  def study_created_email(user, study)
    @user = user
    @study = study
    mail(to: admin_emails, subject: "[#{SITE_NAME}] New study created")
  end

  def dataset_created_email

  end

  private

  def admin_emails
    User.where(admin: true).pluck(:email)
  end
end

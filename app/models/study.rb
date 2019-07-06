class Study < ApplicationRecord
  include Visibility
  has_many :datasets, dependent: :delete_all
  has_many :permissions, dependent: :delete_all
  has_many :users, through: :permissions
  has_many :favorite_studies, dependent: :delete_all
  has_many :favorited_by, through: :favorite_studies, source: :user
  has_many :access_requests, dependent: :delete_all
  has_many :requested_access_by, through: :access_requests, source: :user

  validates :name, :presence => true, :length => { :minimum => 5, :maximum => 50}
  validates :description, :length => { :minimum => 10 }
  validates :visibility, :presence => true
  validates :url, :allow_blank => true, :format => { :with => /https?:\/\/[\S]+/, :message => "Must be a valid full URL." }

  def datatypes
    self.datasets.map(&:datatype)
  end

  def add_member(params)
    error_message = nil
    member = params[:user] || User.find_by_email(params[:email])
    if member.nil?
      error_message = 'There are no users with that email address.'
    else
      permission = Permission.where(user_id: member.id, study_id: self.id).first
      if permission.nil?
        permission = Permission.new(study: self, user: member, access: params[:access])
        unless permission.save
          error_message = 'There was an error adding the user to the study.'
        end
      else
        error_message = 'That user is already a member of the study. Try modifying existing member access.'
      end
    end
    error_message
  end

  def remove_member(params)
    error_message = nil
    if self.permissions.count <= 1
      error_message = 'You cannot remove the only member of the study. Try deleting the study instead.'
    else
      if params.member?(:permission)
        params[:permission].destroy
      else
        permission = Permission.where(user: params[:user], study: params[:study]).first
        permission.nil? ? error_message = 'That user is not a member of that project.' : permission.destroy
      end
    end
    error_message
  end
end

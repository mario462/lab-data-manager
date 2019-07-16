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
  validates :url, :allow_blank => true, :format => { :with => /https?:\/\/[\S]+/, :message => 'must be a valid full URL.' }

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

  def owners
    Permission.where(study: self, access: Access::DESTROY)
  end

  def owned_by?(user)
    !Permission.where(study: self, user: user, access: Access::DESTROY).first.nil?
  end

  def single_owner?(user)
    owners.count <= 1 && owned_by?(user)
  end

  def remove_member(params)
    error_message = nil
    if params.member?(:permission)
      permission = params[:permission]
    else
      permission = Permission.where(user: params[:user], study: params[:study]).first
    end
    if permission.nil?
      error_message = 'That user is not a member of that study.'
    else
      single_owner?(permission.user) ?
          error_message = 'You cannot remove the only owner of a study. Try deleting the study instead.' :
          permission.destroy
    end
    error_message
  end
end

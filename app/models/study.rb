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
    member = User.find_by_email(params[:email])
    if member.nil?
      error_message = 'There are no users with that email address.'
    else
      permission = Permission.where(user_id: member.id, study_id: self.id).first
      unless permission.nil?
        error_message = 'That user is already a member of the study. Try modifying existing member access.'
      else
        permission = Permission.new(study: self, user: member, access: params[:access])
        unless permission.save
          error_message = 'There was an error adding the user to the study.'
        end
      end
    end
    error_message
  end
end

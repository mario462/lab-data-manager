# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can :read, Study do |study|
        study.visibility == Visibility::OPEN_USE || (study.in? user.studies)
      end
      can :edit, Study do |study|
        permission = user.permissions.where(study: study).first
        permission.nil? ? false : (permission.access >= Access::EDIT)
      end
      can :destroy, Study do |study|
        permission = user.permissions.where(study: study).first
        permission.nil? ? false : (permission.access >= Access::DESTROY)
      end
    end
  end
end

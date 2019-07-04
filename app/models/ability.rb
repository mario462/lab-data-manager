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
        (permission.access >= Access::EDIT) unless permission.nil?
      end
      can :destroy, Study do |study|
        permission = user.permissions.where(study: study).first
        (permission.access >= Access::DESTROY) unless permission.nil?
      end
    end
  end
end

# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      if user.admin?
        can :manage, :all
      end
      can [:create, :favorites, :toggle_favorite], Study
      can :read, Study do |study|
        user.can_read?(study)
      end
      can [:edit, :update], Study do |study|
        user.can_edit?(study)
      end
      can :manage, Study do |study|
        user.owner?(study)
      end

      can :read, Dataset do |dataset|
        user.can_read?(dataset.study)
      end
      can [:edit, :update], Dataset do |dataset|
        user.can_edit?(dataset.study)
      end
      can :manage, Dataset do |dataset|
        user.owner(dataset.study)
      end
    end
  end
end

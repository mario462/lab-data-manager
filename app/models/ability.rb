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
      cannot [:approve, :add_member], Study do |_|
        !user.admin?
      end

      can [:read, :download], Dataset do |dataset|
        user.owner?(dataset.study) || (user.can_read?(dataset.study) && !dataset.pending)
      end
      can [:edit, :update], Dataset do |dataset|
        user.owner?(dataset.study) || (user.can_edit?(dataset.study) && !dataset.pending)
      end
      can :manage, Dataset do |dataset|
        user.owner?(dataset.study)
      end
      cannot :approve, Dataset do |_|
        !user.admin?
      end
    end
  end
end

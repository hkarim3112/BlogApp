# frozen_string_literal: true

class ModeratorPolicy < ApplicationPolicy
  def index?
    @user.moderator?
  end

  def publish?
    @user.moderator?
  end

  def unpublish?
    @user.moderator?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end

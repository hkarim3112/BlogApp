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
end

# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, post)
    @user = user
    @post = post
    super
  end

  def index?
    true
  end

  def new?
    true
  end

  def update?
    @user.id == @post.user_id
  end

  def edit?
    update?
  end

  def show?
    true
  end

  def destroy?
    true
  end

  def create?
    true
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if @user.admin?
        super
      else
        scope.all
      end
    end
  end
end

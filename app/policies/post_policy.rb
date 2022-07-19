# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  attr_reader :user, :post

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
    update? || @user.moderator?
  end

  def create?
    true
  end

  def vote?
    @post.published?
  end
end

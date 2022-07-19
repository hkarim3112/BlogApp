# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  attr_reader :user, :comment

  def initialize(user, comment)
    @user = user
    @comment = comment
    super
  end

  def update?
    @user.id == @comment.user_id
  end

  def edit?
    update?
  end

  def destroy?
    update? || @user.moderator? || commentable_owner?
  end

  # in create? function, comment is equal to commentable
  def create?
    post_auth
    # @comment.published?
  end

  private

  def post_auth
    case @comment.class.name
    when 'Post'
      @comment.published?
    when 'Comment'
      @comment.commentable.published?
    end
  end

  def commentable_owner?
    # @comment.commentable.user_id == @user.id

    case @comment.commentable_type
    when 'Post'
      @comment.commentable.user_id == @user.id
    when 'Comment'
      @comment.commentable.user_id == @user.id || @comment.commentable.commentable.user_id == @user.id
    end
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end

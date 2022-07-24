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

  def create?
    @commentable = @comment.commentable
    post_auth
  end

  private

  def post_auth
    case @commentable.class.name
    when 'Post'
      @commentable.published?
    when 'Comment'
      @commentable.commentable.published?
    end
  end

  def commentable_owner?
    case @comment.commentable_type
    when 'Post'
      @comment.commentable.user_id == @user.id
    when 'Comment'
      @comment.commentable.user_id == @user.id || @comment.commentable.commentable.user_id == @user.id
    end
  end
end

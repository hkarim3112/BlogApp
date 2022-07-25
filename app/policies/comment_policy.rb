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
    record = @comment.commentable
    post_auth(record)
  end

  private

  def post_auth(record)
    case record.class.name
    when 'Post'
      record.published?
    when 'Comment'
      record.commentable.published?
    end
  end

  def commentable_owner?
    record = @comment.commentable
    case record.class.name
    when 'Post'
      record.user_id == @user.id
    when 'Comment'
      post = record.commentable
      record.user_id == @user.id || post.user_id == @user.id
    end
  end
end

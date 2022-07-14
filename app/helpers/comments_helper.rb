# frozen_string_literal: true

module CommentsHelper
  def commentable_owner?(commentable)
    case commentable.class.name
    when 'Post'
      commentable.user_id == current_user.id
    when 'Comment'
      commentable.user_id == current_user.id || commentable.commentable.user_id == current_user.id
    end
  end

  def suggestion_reply?(commentable)
    case commentable.class.name
    when 'Post'
      false
    when 'Comment'
      commentable.suggestion
    end
  end
end

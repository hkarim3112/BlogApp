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

  def suggestion?(suggestion, commentable)
    !suggestion && !suggestion_reply?(commentable)
  end

  def delete_btn?(comment, commentable)
    owner?(comment) || current_user.moderator? || commentable_owner?(commentable)
  end

  def edit_btn?(comment, commentable)
    owner?(comment) && !suggestion_reply?(commentable)
  end
end

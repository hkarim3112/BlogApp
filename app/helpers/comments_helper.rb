module CommentsHelper
  def commentable_owner?(comment)
    comment.commentable.user_id == current_user.id
  end
end

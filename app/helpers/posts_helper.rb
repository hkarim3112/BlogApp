# frozen_string_literal: true

module PostsHelper
  def suggestion_btn?(page, post)
    page != 'post-suggestions' && owner?(post)
  end

  def post_delete_btn?(post)
    owner?(post) || current_user.moderator?
  end

  def show_comments?(page, post)
    page == 'post-show' && post.published?
  end
end

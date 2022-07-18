# frozen_string_literal: true

class ModeratorsController < ApplicationController
  # after_action :verify_authorized
  def index
    @pending_posts = Post.pending
    @published_posts = Post.published
    authorize current_user, policy_class: ModeratorPolicy
  end

  def publish
    @post = Post.find(params[:post])
    authorize current_user, policy_class: ModeratorPolicy
    @post.published!
    redirect_back fallback_location: moderator_path
  end

  def unpublish
    @post = Post.find(params[:post])
    authorize current_user, policy_class: ModeratorPolicy
    @post.pending!
    redirect_back fallback_location: moderator_path
  end
end

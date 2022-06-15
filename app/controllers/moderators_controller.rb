# frozen_string_literal: true

class ModeratorsController < ApplicationController
  def index
    authorize current_user, policy_class: ModeratorPolicy
    @status = params[:status] || 'pending'
    @posts = Post.includes(:user).where('status = :status', status: Post.statuses[@status])
  end

  def publish
    authorize current_user, policy_class: ModeratorPolicy
    begin
      @post = Post.find(params[:post])
      @post.published!
      redirect_back fallback_location: moderator_path
    rescue StandardError => e
      logger.error("Message for the log file #{e.message}")
      flash[:alert] = 'Invalid Request'
      redirect_back fallback_location: posts_path
    end
  end

  def unpublish
    authorize current_user, policy_class: ModeratorPolicy
    begin
      @post = Post.find(params[:post])
      @post.pending!
      redirect_back fallback_location: moderator_path
    rescue StandardError => e
      logger.error("Message for the log file #{e.message}")
      flash[:alert] = 'Invalid Request'
      redirect_back fallback_location: posts_path
    end
  end
end

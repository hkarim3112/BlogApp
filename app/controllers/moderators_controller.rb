# frozen_string_literal: true

class ModeratorsController < ApplicationController
  before_action :set_post, only: %i[publish unpublish]

  def index
    authorize current_user, policy_class: ModeratorPolicy
    @status = params[:status] || 'pending'
    @posts = Post.includes(:user).where('status = :status', status: Post.statuses[@status]).order(created_at: :asc)
  end

  def publish
    authorize current_user, policy_class: ModeratorPolicy
    begin
      @post.published!
      redirect_back fallback_location: moderators_path
    rescue StandardError => e
      logger.error("Message for the log file #{e.message}")
      flash[:alert] = 'Invalid Request'
      redirect_back fallback_location: posts_path
    end
  end

  def unpublish
    authorize current_user, policy_class: ModeratorPolicy
    begin
      @post.pending!
      redirect_back fallback_location: moderators_path
    rescue StandardError => e
      logger.error("Message for the log file #{e.message}")
      flash[:alert] = 'Invalid Request'
      redirect_back fallback_location: posts_path
    end
  end
end

private

def set_post
  @post = Post.find(params[:post])
end

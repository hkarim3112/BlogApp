# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    @user = params[:user] || current_user.id
    @user = @user.to_i
    @posts = Post.includes(:user).where(user_id: @user).order(created_at: :desc)
  end

  def user_report
    @reports = current_user.reports
  end

  def user_suggestions
    @suggestions = current_user.comments.where(suggestion: true).order(created_at: :desc)
  end
end

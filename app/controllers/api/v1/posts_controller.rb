# frozen_string_literal: true

class Api::V1::PostsController < ApplicationController
  before_action :set_post, only: [:show]
  skip_before_action :authenticate_user!

  def index
    @posts = Post.published.includes(:user).order(created_at: :desc)
    render json: @posts
  end

  def show
    if @post
      render json: @post
    else
      render json: @post.errors
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end
end

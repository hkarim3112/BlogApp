# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy vote suggestions]
  respond_to :js, :json, :html

  def index
    @posts = Post.published.includes(:user).order(created_at: :desc)
  end

  def show; end

  def suggestions; end

  def new
    @post = current_user.posts.build
  end

  def edit
    authorize @post
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to post_url(@post), notice: 'Post was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      redirect_to post_url(@post), notice: 'Post was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @post
    @post.destroy

    redirect_back fallback_location: posts_url, notice: 'Post was successfully destroyed.'
  end

  def vote
    authorize @post
    if !current_user.liked? @post
      @post.liked_by current_user
    elsif current_user.liked? @post
      @post.unliked_by current_user
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end

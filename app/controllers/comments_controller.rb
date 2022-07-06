# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy edit update vote]
  before_action :find_commentable, only: %i[create edit new]
  respond_to :js, :json, :html

  def edit
    authorize @comment
  end

  def update
    authorize @comment
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment.commentable, notice: 'Comment Updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def new
    @comment = Comment.new
  end

  def create
    authorize @commentable, policy_class: CommentPolicy
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.js { render inline: '$("#comments-section").load(location.href+" #comments-section>*","");' }
      else
        format.js { render :create, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @comment
    @comment.destroy

    respond_to do |format|
      format.js { render inline: '$("#comments-section").load(location.href+" #comments-section>*","");' }
    end
  end

  def vote
    if !current_user.liked? @comment
      @comment.liked_by current_user
    elsif current_user.liked? @comment
      @comment.unliked_by current_user
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def find_commentable
    if params[:post_id]
      @commentable = Post.find(params[:post_id])
    elsif params[:comment_id]
      @commentable = Comment.find(params[:comment_id])
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end

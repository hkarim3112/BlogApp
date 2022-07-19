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
    if @comment.update(comment_params)
      update_page
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def new
    @comment = Comment.new
    @toggle = true
  end

  def create
    authorize @commentable, policy_class: CommentPolicy
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    # @comment.suggestion = true if params[:suggestion] == 'true'
    if @comment.save
      create_page
    else
      respond_to do |format|
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

  # def suggestions; end

  def new_suggestion
    @comment = Comment.new
    @commentable = Post.find(params[:id])
  end

  private

  def update_page
    respond_to do |format|
      case @comment.commentable_type
      when 'Post'
        format.html { redirect_to @comment.commentable, notice: 'comment updated.' }
      when 'Comment'
        format.html { redirect_to @comment.commentable.commentable, notice: 'comment updated.' }
      end
    end
  end

  def create_page
    respond_to do |format|
      case @comment.commentable_type
      when 'Post'
        format.html { redirect_to @commentable }
        format.js { render inline: '$("#comments-section").load(location.href+" #comments-section>*","");' }
      when 'Comment'
        @comment = Comment.new
        @toggle = false
        format.js { render :new }
      end
    end
  end

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
    params.require(:comment).permit(:content, :suggestion)
  end
end

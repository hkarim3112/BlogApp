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
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @comment = Comment.new
    @toggle = true
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    authorize @comment, policy_class: CommentPolicy
    if @comment.save
      create_page
    else
      render :create, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @comment
    @comment.destroy

    render inline: '$("#comments-section").load(location.href+" #comments-section>*","");'
  end

  def vote
    if !current_user.liked? @comment
      @comment.liked_by current_user
    elsif current_user.liked? @comment
      @comment.unliked_by current_user
    end
  end

  def new_suggestion
    @comment = Comment.new
    @commentable = Post.find(params[:id])
  end

  private

  def update_page
    record = @comment.commentable
    case record.class.name
    when 'Post'
      redirect_to record, notice: 'comment updated.'
    when 'Comment'
      record = record.commentable
      redirect_to record, notice: 'comment updated.'
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

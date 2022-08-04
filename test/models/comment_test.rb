# frozen_string_literal: true

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @comment = comments(:testcomment1)
  end

  test 'valid comment' do
    assert @comment.valid?
  end

  test 'invalid without content' do
    @comment.content = nil
    assert_not @comment.valid?, 'comment is valid without a content'
    assert_not_nil @comment.errors[:content], 'no validation for content present'
  end

  test 'invalid without user' do
    @comment.user = nil
    assert_not @comment.valid?, 'comment is valid without a user'
  end

  test 'invalid without commentable' do
    @comment.commentable = nil
    assert_not @comment.valid?, 'comment is valid without a commentable'
  end

  test '#comments' do
    assert_equal 2, @comment.comments.size
  end

  test '#reports' do
    assert_equal 2, @comment.reports.size
  end
end

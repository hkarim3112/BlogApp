# frozen_string_literal: true

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @post = posts(:blog1)
  end

  test 'valid post' do
    assert @post.valid?
  end

  test 'invalid without title' do
    @post.title = nil
    assert_not @post.valid?, 'post is valid without a title'
    assert_not_nil @post.errors[:title], 'no validation for title present'
  end

  test 'invalid without content' do
    @post.content = nil
    assert_not @post.valid?, 'post is valid without a content'
    assert_not_nil @post.errors[:content], 'no validation for content present'
  end

  test 'invalid if title greater than 100' do
    @post.title = 'qwertyuiopasdfghjklzxcvbnm qwertyuiopasdfghjklzxcvbnm
    [] 1234567890 qwertyuiopasdfghjklzxcvbnm 1234567890'
    assert_not @post.valid?, 'no validation for title length'
  end

  test 'invalid without user' do
    @post.user = nil
    assert_not @post.valid?, 'post is valid without a user'
  end

  test '#comments' do
    assert_equal 2, @post.comments.size
  end

  test '#reports' do
    assert_equal 2, @post.reports.size
  end
end

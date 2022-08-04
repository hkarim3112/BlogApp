# frozen_string_literal: true

require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @users = User.all
    @users.each(&:confirm)
    sign_in @users[0]
    @post = posts(:blog1)
  end

  test 'should get index' do
    get posts_url
    assert_response :success
  end

  test 'should not get index if unauthorized' do
    sign_out @users[0]
    get posts_url
    assert_response :redirect
  end

  test 'should get new' do
    get new_post_url
    assert_response :success
  end

  test 'should create post' do
    assert_difference('Post.count') do
      post posts_url, params: { post: { content: @post.content, title: @post.title } }
    end

    assert_redirected_to post_url(Post.last)
  end

  test 'should not create post if invalid params' do
    assert_no_difference('Post.count') do
      post posts_url, params: { post: { content: '', title: '' } }
    end
    assert_template :new
  end

  test 'should show post' do
    get post_url(@post)
    assert_response :success
  end

  test 'should get post suggestions' do
    get suggestions_post_url(@post)
    assert_response :success
  end

  test 'should get edit' do
    get edit_post_url(@post)
    assert_response :success
  end

  test 'should not get edit if not owner' do
    sign_in @users[2]
    get edit_post_url(@post)
    assert_response :redirect
  end

  test 'should update post' do
    patch post_url(@post), params: { post: { content: @post.content, title: @post.title } }
    assert_redirected_to post_url(@post)
  end

  test 'should not update post if invalid params' do
    patch post_url(@post), params: { post: { content: '', title: '' } }
    assert_template :edit
  end

  test 'should destroy post if owner' do
    assert_difference('Post.count', -1) do
      delete post_url(@post)
    end

    assert_redirected_to root_url
  end

  test 'should not destroy post if not owner' do
    sign_in @users[2]
    assert_no_difference('Post.count') do
      delete post_url(@post)
    end

    assert_response :redirect
  end

  test 'should destroy post if moderator' do
    sign_in @users[1]
    assert_difference('Post.count', -1) do
      delete post_url(@post)
    end

    assert_redirected_to root_url
  end

  test 'should like or unlike post if published' do
    @post.published!
    put like_post_url(@post), xhr: true
    assert @users[0].liked? @post
    put like_post_url(@post), xhr: true
    assert_not @users[0].liked? @post
  end

  test 'should not like post if unpublished' do
    put like_post_url(@post), xhr: true
    assert_not @users[0].liked? @post
  end
end

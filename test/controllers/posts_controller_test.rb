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
    assert_template :index
  end

  test 'should not get index if unauthorized' do
    sign_out @users[0]
    get posts_url
    assert_equal "You need to sign in or sign up before continuing.", flash[:alert]
    assert_redirected_to new_user_session_url
  end

  test 'should get new' do
    get new_post_url
    assert_response :success
    assert_template :new
  end

  test 'should create post' do
    assert_difference('Post.count') do
      post posts_url, params: { post: { content: @post.content, title: @post.title } }
    end

    assert_equal "Post was successfully created.", flash[:notice]
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
    assert_template :show
  end

  test 'should raise 404 on show post if invalid id' do
    get post_url(1234)
    assert_response :not_found
  end

  test 'should get post suggestions' do
    get suggestions_post_url(@post)
    assert_response :success
    assert_template :suggestions
  end

  test 'should raise 404 on suggestions if invalid id' do
    get suggestions_post_url(1234)
    assert_response :not_found
  end

  test 'should get edit' do
    get edit_post_url(@post)
    assert_response :success
    assert_template :edit
  end

  test 'should raise 404 on edit if invalid id' do
    get edit_post_url(1234)
    assert_response :not_found
  end

  test 'should not get edit if not owner' do
    sign_in @users[2]
    get edit_post_url(@post)
    assert_equal "You are not authorized to perform this action.", flash[:alert]
    assert_response :redirect
    assert_redirected_to root_url
  end

  test 'should update post' do
    patch post_url(@post), params: { post: { content: @post.content, title: @post.title } }
    assert_equal "Post was successfully updated.", flash[:notice]
    assert_redirected_to post_url(@post)
  end

  test 'should raise 404 on update if invalid id' do
    patch post_url(1234), params: {post: { content: @post.content, title: @post.title }}
    assert_response :not_found
  end

  test 'should not update post if invalid params' do
    patch post_url(@post), params: { post: { content: '', title: '' } }
    assert_template :edit
  end

  test 'should destroy post if owner' do
    assert_difference('Post.count', -1) do
      delete post_url(@post)
    end

    assert_equal "Post was successfully destroyed.", flash[:notice]
    assert_redirected_to root_url
  end

  test 'should raise 404 on destroy if invalid id' do
    delete post_url(1234)
    assert_response :not_found
  end

  test 'should not destroy post if not owner' do
    sign_in @users[2]
    assert_no_difference('Post.count') do
      delete post_url(@post)
    end

    assert_equal "You are not authorized to perform this action.", flash[:alert]
    assert_redirected_to root_url
  end

  test 'should destroy post if moderator' do
    sign_in @users[1]
    assert_difference('Post.count', -1) do
      delete post_url(@post)
    end

    assert_equal "Post was successfully destroyed.", flash[:notice]
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
    assert_equal "You are not authorized to perform this action.", flash[:alert]
  end

  test 'should raise 404 on like if invalid id' do
    put like_post_url(1234), xhr: true
    assert_response :not_found
  end
end

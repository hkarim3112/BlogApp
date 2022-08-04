# frozen_string_literal: true

require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @users = User.all
    @users.each(&:confirm)
    sign_in @users[0]
    @report = reports(:testreport1)
  end

  test 'should get index if moderator' do
    sign_in @users[1]
    get reports_url
    assert_response :success
  end

  test 'should not get index if not moderator' do
    get reports_url
    assert_response :redirect
  end

  test 'should get new' do
    get new_comment_report_path(comments(:testcomment1))
    assert_response :success
    get new_post_report_path(posts(:blog3))
    assert_response :success
  end

  test 'should create on post if not owner of post' do
    @post = posts(:blog3)
    @post.published!
    assert_difference('Report.count') do
      post post_reports_url(@post), params: { report: { report_type: 'irrelevant' } }
    end

    assert_redirected_to post_url(Report.last.reportable)
  end

  test 'should create on comment if not owner of comment' do
    sign_in @users[2]
    @post = posts(:blog1)
    @post.published!
    @comment = comments(:testcomment1)
    assert_difference('Report.count') do
      post comment_reports_url(@comment), params: { report: { report_type: 'irrelevant' } }
    end

    assert_redirected_to post_url(Report.last.reportable.commentable)
  end

  test 'should create on reply if not owner of reply' do
    sign_in @users[2]
    @post = posts(:blog1)
    @post.published!
    @comment = comments(:testcomment3)
    assert_difference('Report.count') do
      post comment_reports_url(@comment), params: { report: { report_type: 'irrelevant' } }
    end

    assert_redirected_to post_url(Report.last.reportable.commentable.commentable)
  end

  test 'should not create if owner of reportable' do
    @post = posts(:blog1)
    @post.published!
    assert_no_difference('Report.count') do
      post post_reports_url(@post), params: { report: { report_type: 'irrelevant' } }
    end

    assert_response :redirect
  end

  test 'should not create if reportable post is unpublished' do
    @post = posts(:blog3)
    assert_no_difference('Report.count') do
      post post_reports_url(@post), params: { report: { report_type: 'irrelevant' } }
    end

    assert_response :redirect
  end

  test 'should get edit' do
    get edit_report_url(@report)
    assert_response :success
  end

  test 'should not get edit if not owner' do
    sign_in @users[1]
    get edit_report_url(@report)
    assert_response :redirect
  end

  test 'should update report' do
    patch report_url(@report), params: { report: { report_type: @report.report_type } }
    assert_redirected_to post_url(@report.reportable)
  end

  test 'should not update report if not owner' do
    sign_in @users[1]
    patch report_url(@report), params: { report: { report_type: @report.report_type } }
    assert_response :redirect
  end

  test 'should destroy report' do
    assert_difference('Report.count', -1) do
      delete report_url(@report), xhr: true
    end
  end

  test 'should destroy report if moderator' do
    sign_in @users[1]
    assert_difference('Report.count', -1) do
      delete report_url(@report), xhr: true
    end
  end

  test 'should not destroy report if not owner' do
    sign_in @users[2]
    assert_no_difference('Report.count') do
      delete report_url(@report), xhr: true
    end
  end
end

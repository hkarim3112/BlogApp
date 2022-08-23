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
    assert_template :index
  end

  test 'should not get index if not moderator' do
    get reports_url
    assert_equal "You are not authorized to perform this action.", flash[:alert]
    assert_redirected_to root_url
  end

  test 'should get new for post' do
    get new_post_report_path(posts(:blog3))
    assert_response :success
    assert_template :new
  end

  test 'should get new for comment' do
    get new_comment_report_path(comments(:testcomment1))
    assert_response :success
    assert_template :new
  end

  test 'should create on post if not owner of post' do
    @post = posts(:blog3)
    @post.published!
    assert_difference('Report.count') do
      post post_reports_url(@post), params: { report: { report_type: 'irrelevant' } }
    end

    assert_equal "Reported.", flash[:notice]
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

    assert_equal "Reported.", flash[:notice]
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

    assert_equal "Reported.", flash[:notice]
    assert_redirected_to post_url(Report.last.reportable.commentable.commentable)
  end

  test 'should not create if owner of reportable' do
    @post = posts(:blog1)
    @post.published!
    assert_no_difference('Report.count') do
      post post_reports_url(@post), params: { report: { report_type: 'irrelevant' } }
    end

    assert_equal "You are not authorized to perform this action.", flash[:alert]
    assert_redirected_to root_url
  end

  test 'should not create if reportable post is unpublished' do
    @post = posts(:blog3)
    assert_no_difference('Report.count') do
      post post_reports_url(@post), params: { report: { report_type: 'irrelevant' } }
    end

    assert_equal "You are not authorized to perform this action.", flash[:alert]
    assert_redirected_to root_url
  end

  test 'should not create if invalid report type' do
    @post = posts(:blog3)
    @post.published!
    assert_no_difference('Report.count') do
      post post_reports_url(@post), params: { report: { report_type: '' } }
    end

    assert_template :new
  end

  test 'should get edit' do
    get edit_report_url(@report)
    assert_response :success
    assert_template :edit
  end

  test 'should raise 404 on edit report if invalid id' do
    get edit_report_url(1234)
    assert_response :not_found
  end

  test 'should not get edit if not owner' do
    sign_in @users[1]
    get edit_report_url(@report)
    assert_equal "You are not authorized to perform this action.", flash[:alert]
    assert_redirected_to root_url
  end

  test 'should update report' do
    patch report_url(@report), params: { report: { report_type: @report.report_type } }
    assert_equal "Reported.", flash[:notice]
    assert_redirected_to post_url(@report.reportable)
  end

  test 'should raise 404 on update report if invalid id' do
    patch report_url(1234), params: { report: { report_type: @report.report_type } }
    assert_response :not_found
  end

  test 'should not update report if not owner' do
    sign_in @users[1]
    patch report_url(@report), params: { report: { report_type: @report.report_type } }
    assert_equal "You are not authorized to perform this action.", flash[:alert]
    assert_redirected_to root_url
  end

  test 'should not update report if invalid report type' do
    patch report_url(@report), params: { report: { report_type: '' } }
    assert_template :edit
  end

  test 'should destroy report' do
    assert_difference('Report.count', -1) do
      delete report_url(@report), xhr: true
    end
  end

  test 'should raise 404 on destroy report if invalid id' do
    delete report_url(1234), xhr: true
    assert_response :not_found
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
    assert_equal "You are not authorized to perform this action.", flash[:alert]
  end
end

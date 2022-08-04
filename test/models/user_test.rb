# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:validUser)
  end

  test 'valid user' do
    assert @user.valid?, 'invalid user'
  end

  test 'invalid without name' do
    @user.name = nil
    assert_not @user.valid?, 'user is valid without a name'
    assert_not_nil @user.errors[:name], 'no validation for name present'
  end

  test 'invalid without email' do
    @user.email = nil
    assert_not @user.valid?, 'user is valid without an email'
    assert_not_nil @user.errors[:email], 'no validation for email present'
  end

  test '#posts' do
    assert_equal 2, @user.posts.size
  end

  test '#comments' do
    assert_equal 2, @user.comments.size
  end

  test '#reports' do
    assert_equal 2, @user.reports.size
  end
end

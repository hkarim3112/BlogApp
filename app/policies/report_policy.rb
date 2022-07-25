# frozen_string_literal: true

class ReportPolicy < ApplicationPolicy
  attr_accessor :user, :report

  def initialize(user, report)
    @user = user
    @report = report
    super
  end

  def index?
    @user.moderator?
  end

  def new?
    create?
  end

  def update?
    @user.id == @report.user_id
  end

  def edit?
    update?
  end

  def destroy?
    update? || @user.moderator?
  end

  def create?
    @record = @report.reportable
    @record.user_id != @user.id && !@record.reported?(@user.id) && reportable_auth
  end

  private

  def reportable_auth
    case @record.class.name
    when 'Post'
      @record.published?
    when 'Comment'
      @record = @record.commentable
      reportable_auth
    end
  end
end

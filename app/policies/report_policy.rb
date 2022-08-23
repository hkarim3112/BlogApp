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
    @record.user_id != @user.id && !reported?(@record) && reportable_auth
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

  def reported?(reportable)
    find_report(reportable).exists?
  end

  def find_report(reportable)
    reportable.reports.where(user_id: @user.id)
  end
end

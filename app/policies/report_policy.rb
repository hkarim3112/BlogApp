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
    @report.user_id != @user.id && !@report.reported?(@user.id) && reportable_auth
  end

  private

  def reportable_auth
    case @report.class.name
    when 'Post'
      @report.published?
    when 'Comment'
      @report = @report.commentable
      reportable_auth
      # @report.commentable.published?
    end
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end

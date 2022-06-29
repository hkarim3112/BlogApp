# frozen_string_literal: true

class ReportPolicy < ApplicationPolicy
  attr_reader :user, :post

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
    @report.published? && @report.user_id != @user.id
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end

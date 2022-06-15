# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # rails_admin actions start
  def index?
    @user.admin?
  end

  def dashboard?
    @user.admin?
  end

  def export?
    @user.admin?
  end

  def bulk_delete?
    @user.admin?
  end

  def delete?
    @user.admin?
  end

  def show_in_app?
    @user.admin?
  end

  def edit?
    @user.admin?
  end

  def new?
    @user.admin?
  end

  def show?
    @user.admin?
  end

  # rails_admin actions end

  def create?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    attr_reader :user, :scope
  end
end

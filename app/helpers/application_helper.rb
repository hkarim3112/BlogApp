# frozen_string_literal: true

module ApplicationHelper
  def owner?(record)
    record.user_id == current_user.id
  end

  def reported?(reportable)
    get_report(reportable).exists?
  end

  def get_report(reportable)
    reportable.reports.where(user_id: current_user.id)
  end
end

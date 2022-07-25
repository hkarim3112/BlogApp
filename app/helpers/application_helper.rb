# frozen_string_literal: true

module ApplicationHelper
  def owner?(record)
    record.user_id == current_user.id
  end

  def reported?(reportable)
    find_report(reportable).exists?
  end

  def find_report(reportable)
    reportable.reports.where(user_id: current_user.id)
  end
end

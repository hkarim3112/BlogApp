# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  def setup
    @report = reports(:testreport1)
  end

  test 'valid report' do
    assert @report.valid?
  end

  test 'invalid without report_type' do
    @report.report_type = nil
    assert_not @report.valid?
  end

  test 'invalid without user' do
    @report.user = nil
    assert_not @report.valid?, 'report is valid without a user'
  end

  test 'invalid without reportable' do
    @report.reportable = nil
    assert_not @report.valid?, 'report is valid without a reportable'
  end
end

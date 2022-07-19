# frozen_string_literal: true

class ReportsController < ApplicationController
  def index
    @reports = Report.all
  end
end

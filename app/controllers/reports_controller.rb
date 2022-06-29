# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :find_reportable, only: %i[create new]
  before_action :set_report, only: %i[edit destroy update]

  def index
    authorize current_user, policy_class: ReportPolicy
    @reports = Report.includes(:user).all
  end

  def new
    authorize @reportable, policy_class: ReportPolicy
    @report = current_user.reports.build
  end

  def edit
    authorize @report
  end

  def create
    authorize @reportable, policy_class: ReportPolicy
    @report = @reportable.reports.new(report_params)
    @report.user = current_user
    if @report.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Post Reported.' }
      end
    else
      format.html { render :new, status: :unprocessable_entity }
    end
  end

  def update
    authorize @report
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to root_path, notice: 'Reported Updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @report
    @report.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: 'Report was successfully deleted.' }
    end
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def find_reportable
    if params[:post_id]
      @reportable = Post.find(params[:post_id])
    elsif params[:comment_id]
      @reportable = Comment.find(params[:comment_id])
    end
  end

  def report_params
    params.require(:report).permit(:report_type)
  end
end

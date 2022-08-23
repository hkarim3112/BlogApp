# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :find_reportable, only: %i[create new edit]
  before_action :set_report, only: %i[edit destroy update]

  def index
    authorize current_user, policy_class: ReportPolicy
    @reports = Report.includes(:user).all
  end

  def new
    @report = current_user.reports.build
  end

  def edit
    authorize @report
  end

  def create
    @report = @reportable.reports.new(report_params)
    @report.user = current_user
    authorize @report, policy_class: ReportPolicy
    if @report.save
      page
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @report
    if @report.update(report_params)
      page
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @report
    @report.destroy
    render inline: 'location.reload();'
  end

  private

  def page
    record = @report.reportable
    case record.class.name
    when 'Post'
      @go_to_page = record
    when 'Comment'
      record = record.commentable
      case record.class.name
      when 'Post'
        @go_to_page = record
      when 'Comment'
        record = record.commentable
        @go_to_page = record
      end
    end
    redirect_to @go_to_page, notice: 'Reported.'
  end

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

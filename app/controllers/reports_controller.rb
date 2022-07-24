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
      format.html { render :new, status: :unprocessable_entity }
    end
  end

  def update
    authorize @report
    if @report.update(report_params)
      page
    else
      format.html { render :edit, status: :unprocessable_entity }
    end
  end

  def destroy
    authorize @report
    @report.destroy
    render inline: 'location.reload();'
  end

  private

  def page
    case @report.reportable_type
    when 'Post'
      @go_to_page = @report.reportable
    when 'Comment'
      case @report.reportable.commentable_type
      when 'Post'
        @go_to_page = @report.reportable.commentable
      when 'Comment'
        @go_to_page = @report.reportable.commentable.commentable
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

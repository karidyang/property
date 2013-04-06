class ReportController < ApplicationController
  def user_report
    @user_reports = UserReport.find_by_user(params[:start_time], params[:end_time])
  end

  def user_report_detail
    if params[:item_id]
      @user_reports = UserReport.where('item_id=? and operator=? and (pay_money>0 or pre_money>0) ', params[:item_id], params[:user])
      render 'user_report_detail_item'
    else
      @user_reports = UserReport.find_by_user_detail(params[:user])
    end
  end

end

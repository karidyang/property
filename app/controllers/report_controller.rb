# -*- encoding : utf-8 -*-
#coding:utf-8
class ReportController < ApplicationController
  def user_report
    unless @current_user.has_privilege?('reports', 'user_report')
      miss_privilege
      return
    end
    @user_reports = UserReport.find_by_user(params[:start_time], params[:end_time],current_plot)
  end

  def user_report_detail
    unless @current_user.has_privilege?('reports', 'user_report')
      miss_privilege
      return
    end
    if params[:item_id]
      @user_reports = UserReport.where('item_id=? and operator=? and (pay_money>0 or pre_money>0) ', params[:item_id], params[:user])
      render 'user_report_detail_item'
    else
      @user_reports = UserReport.find_by_user_detail(params[:user])
    end
  end

  def pay_report
    unless @current_user.has_privilege?('reports', 'pay_report')
      miss_privilege
      return
    end
    @pay_reports = PayReport.paginate(:page => params[:page])
    render layout: 'admin'

  end

  def unpay_report
    unless @current_user.has_privilege?('reports', 'unpay_report')
      miss_privilege
      return
    end
    @unpay_reports = UnpayReport.paginate(:page => params[:page])
    render layout: 'admin'
  end

end

#coding:utf-8
class ReportController < ApplicationController
  def user_report
    if !@current_user.has_privilege?('reports', 'user_report')
      flash[:now] = '你没有查看收费员报表的权限，请联系管理员'
      render_403
      return
    end
    @user_reports = UserReport.find_by_user(params[:start_time], params[:end_time])
  end

  def user_report_detail
    if !@current_user.has_privilege?('reports', 'user_report')
      flash[:now] = '你没有查看收费员报表的权限，请联系管理员'
      render_403
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
    if !@current_user.has_privilege?('reports', 'pay_report')
      flash[:now] = '你没有查看收费报表的权限，请联系管理员'
      render_403
      return
    end
    @pay_reports = PayReport.paginate(:page => params[:page])
    render layout: 'admin'

  end

  def unpay_report
    if !@current_user.has_privilege?('reports', 'unpay_report')
      flash[:now] = '你没有查看收费员报表的权限，请联系管理员'
      render_403
      return
    end
    @unpay_reports = UnpayReport.paginate(:page => params[:page])
    render layout: 'admin'
  end

end

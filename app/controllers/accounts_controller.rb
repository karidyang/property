# -*- encoding : utf-8 -*-
class AccountsController < ApplicationController
  before_filter :require_user
  #around_filter do |controller, action|
  #  if @current_user.has_privilege?(controller.controller_name, controller.action_name)
  #    action.call
  #  else
  #    flash[:notice] = "你没有#{controller.controller_name}.#{controller.action_name}权限，请联系管理员"
  #    render_403
  #  end
  #end

  # GET /accounts
  # GET /accounts.xml
  def index
    unless @current_user.has_privilege?('accounts', 'index')
      miss_privilege
      return
    end
    @house_id = params[:house_id]
    @accounts = Account.where('house_id=?', @house_id).paginate(:page => params[:page])
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    unless @current_user.has_privilege?('accounts', 'destroy')
      miss_privilege
      return
    end

    @account = Account.find(params[:id])
    @account.destroy if !@account.nil?

    redirect_to(accounts_url)

  end

  def history
    unless @current_user.has_privilege?('accounts', 'history')
      miss_privilege
      return
    end
    @account = Account.find(params[:id])
    @details = @account.account_details.paginate(:page => params[:page])
  end

  def add_pre_money
    unless @current_user.has_privilege?('accounts', 'add_pre_money')
      miss_privilege
      return
    end
    @house = House.find(params[:house_id])
    if request.post?

      if Account.add_pre_money(params, @current_user.name)
        redirect_to :controller => 'home', :action => :index, :id => params[:house_id]
      else
        flash.now[:error] = '预存款错误'
        @items = Charge.find_all_by_plot_id(session[:current_plot])
        render 'add_pre_money'
      end
    else
      @items = Charge.find_all_by_plot_id(session[:current_plot])
      render 'add_pre_money'
    end
  end

  def delete_detail
    unless @current_user.has_privilege?('accounts', 'delete_detail')
      miss_privilege
      return
    end
    @detail = AccountDetail.find(params['detail_id'])
    @account = @detail.account
    if @detail
      if @account.del_detail(@detail)

        redirect_to :controller => :accounts, :action => :history, :id => @account.id
      end
    end
  end

  def transcation
    unless @current_user.has_privilege?('accounts', 'transcation')
      miss_privilege
      return
    end
    if request.post?

      @src_account = Account.find(params[:account_id])

      begin
        @src_account.transcation_to(params, @current_user.name)
        redirect_to :controller => :accounts, :action => :index, :house_id => params[:house_id]
        raise

      end
    else
      @account = Account.find(params[:account_id])
      @src_item_id = params[:src_item_id]
      @items = Charge.where('plot_id=? and id!=?', @account.plot_id, @src_item_id)

    end
  end
end

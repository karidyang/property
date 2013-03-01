# coding: utf-8  
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
    @house_id = params[:house_id]
    @accounts = Account.where('house_id=?', @house_id).paginate(:page=>params[:page])

  end

  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    if @current_user.has_privilege?('accounts', 'delete')
      @account = Account.find(params[:id])
      @account.destroy if !@account.nil?

      redirect_to(accounts_url)
    else
      flash[:notice] = '你没有删除预存款的权限，请联系管理员'
      render_403

    end

  end

  def history
    @account = Account.find(params[:id])
    @details = @account.account_details.paginate(:page=>params[:page])
  end

  def add_pre_money
    if @current_user.has_privilege?('accounts', 'insert')
      flash[:notice] = '你没有添加预存款的权限，请联系管理员'
      render_403
      return
    end
    @house = House.find(params[:house_id])
    if request.post?
      #@detail = AccountDetail.new
      #@detail.unit_price=params[:unitPrice]
      #@detail.record = params[:record]
      #@detail.can_push=params[:can_push]
      #@detail.money = params[:money]
      #
      #@account = Account.find_by_item_id_and_house_id(params[:item_id], params[:house_id])
      #@charge = Charge.find(params[:item_id])
      #
      #if @account.nil?
      #  @account = Account.create(:house_id=>params[:house_id],
      #                            :house_code=>params[:house_code],
      #                            :item_id=>params[:item_id],
      #                            :item_name=>@charge.item_name,
      #                            :plot_id=>params[:plot_id])
      #
      #end
      #
      #@account.transcation_in(@detail)

      if Account.add_pre_money(params,@current_user.name)
        redirect_to :controller => :accounts, :action => :index, :house_id => params[:house_id]
      else
        @items = Charge.find_all_by_plot_id(session[:current_plot])
        render 'add_pre_money'
      end
    else
      @items = Charge.find_all_by_plot_id(session[:current_plot])
      render 'add_pre_money'
    end
  end

  def delete_detail
    @detail = AccountDetail.find(params['detail_id'])
    @account = @detail.account
    if @detail
      if @account.del_detail(@detail)

        redirect_to :controller => :accounts, :action => :history, :id => @account.id
      end
    end
  end

  def transcation
    if request.post?

      @src_account = Account.find(params[:account_id])

      begin
        @src_account.transcation_to(params,@current_user.name)
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

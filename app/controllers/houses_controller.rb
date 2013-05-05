# coding: utf-8
class HousesController < ApplicationController
  before_filter :require_user
  #around_filter do |controller, action|
  #  if !@current_user.has_privilege?(controller.controller_name, controller.action_name)
  #    flash[:now] = "你没有#{controller.controller_name}.#{controller.action_name}权限，请联系管理员"
  #    render_403
  #  else
  #    action.call
  #  end
  #end
  # GET /houses
  # GET /houses.xml
  def index
    if !@current_user.has_privilege?('houses', 'index')
      flash[:now] = '你没有浏览房间列表的权限，请联系管理员'
      render_403
      return
    end
    house_code = params[:house_code]
    plot_id = params[:plot_id] || session[:current_plot]
    #logger.info "plot_id=#{plot_id}, house_code=#{house_code}"
    @houses = House.find_house(plot_id, house_code).paginate(:page => params[:page])

  end

  # GET /houses/1
  # GET /houses/1.xml
  def show
    @house = House.find(params[:id])
  end

  # GET /houses/new
  # GET /houses/new.xml
  def new
    if @current_user.has_privilege?('houses', 'create')
      @house = House.new
    else
      flash[:now] = '您没有新增房间的权限,请联系管理员'
      render_403

    end
  end

  # GET /houses/1/edit
  def edit
    if @current_user.has_privilege?('houses', 'update')
      @house = House.find(params[:id])
    else
      flash[:now] = '您没有编辑房间的权限,请联系管理员'
      render_403
    end
  end

  # POST /houses
  # POST /houses.xml
  def create
    if @current_user.has_privilege?('houses', 'create')
      @house = House.new(params[:house])
      @area = @house.area
      @house.plot = @area.plot

      if @house.save
        redirect_to(houses_url, :now => '新建房间成功.')

      else
        render :action => 'new'

      end
    else
      flash[:now] = '您没有新增房间的权限,请联系管理员'
      render_403

    end

  end

  # PUT /houses/1
  # PUT /houses/1.xml
  def update
    if @current_user.has_privilege?('houses', 'update')
      @house = House.find(params[:id])

      if @house.update_attributes(params[:house])
        redirect_to(houses_url, :now => '更新房间成功.')
      else
        render :action => 'edit'
      end
    else
      flash[:now] = '您没有编辑房间的权限,请联系管理员'
      render_403

    end

  end

  # DELETE /houses/1
  # DELETE /houses/1.xml
  def destroy
    if @current_user.has_privilege?('houses', 'destroy')
      @house = House.find(params[:id])
      if @house
        @house.destroy
      end
      redirect_to(houses_url)
    else
      flash[:now] = '您没有删除房间的权限,请联系管理员'
      render_403

    end
  end

  def house_tree
    if @current_user.has_privilege?('houses', 'index')
      @plots = @current_user.plots
      logger.info "----------------------------------"
      logger.info "session[:current_plot]=#{session[:current_plot]}"
      logger.info "----------------------------------"

      json = []
      @plots.each { |plot| json << plot.to_json if plot.id==session[:current_plot] }
      render :json => "[#{json.join(',')}]"
    else
      render :json => "[]"
    end
  end

  def house_info
    if !@current_user.has_privilege?('houses', 'index')
      flash[:now] = '你没有浏览房间列表的权限，请联系管理员'
      render_403
      return
    end
    house_code = params[:house_code]
    logger.debug("house_code=#{house_code}")

    house = House.where('house_code=? and plot_id=?', house_code, session[:current_plot]).first


    bill_items_json = Array.new
    house.unpay_bills.each do |bill|
      bill.bill_items.each do |bill_item|
        bill_items_json << bill_item.json
      end
    end
    pay_bill_items_json = Array.new
    house.pay_bills.each do |bill|
      bill.bill_items.each do |bill_item|
        pay_bill_items_json << bill_item.json
      end
    end
    accounts_json = Array.new

    house.accounts.each do |account|
      accounts_json << account.json
    end

    render :json => {house: house.json, bill_items: bill_items_json, pay_bill_items: pay_bill_items_json, accounts: accounts_json}
  end

  def info

    render 'home/_house_info', layout: 'iframe'
  end

  def add_house_charge
    if !@current_user.has_privilege?('houses', 'add_house_charge')
      flash[:now] = '你没有绑定房间收费项目的权限，请联系管理员'
      render_403
      return
    end
    @house = House.find(params[:id])
    if request.post?
      if params.include?(:house)
        params[:house][:charge_ids] ||= []
        if @house.update_attributes(params[:house])
          flash[:now] = '绑定收费项目成功.'
        end
      else
        @house.charges = []
        if @house.save!
          flash[:now] = '绑定收费项目成功.'
        end
      end
      redirect_to controller: 'home', action: 'index', id: @house.id
    else
      @charges = Charge.find_all_by_plot_id(session[:current_plot])
    end
  end

end

#coding: utf-8
class ChargesController < ApplicationController
  before_filter :require_user
  around_filter do |controller, action|
    if !@current_user.has_privilege?(controller.controller_name, controller.action_name)
      flash[:notice] = "你没有#{controller.controller_name}.#{controller.action_name}权限，请联系管理员"
      render_403
    else
      action.call
    end
  end
  # GET /charges
  # GET /charges.xml
  def index
    @charges = Charge.page params[:page]
  end

  # GET /charges/new
  # GET /charges/new.xml
  def new
    if !@current_user.has_privilege?('charges', 'insert')
      flash[:notice] = "你没有新建收费项目的权限，请联系管理员"
      render_403
      return
    end
    @charge = Charge.new
  end

  # GET /charges/1/edit
  def edit
    if !@current_user.has_privilege?('charges', 'update')
      flash[:notice] = "你没有修改收费项目的权限，请联系管理员"
      render_403
      return
    end
    @charge = Charge.find(params[:id])
  end

  # POST /charges
  # POST /charges.xml
  def create
    if !@current_user.has_privilege?('charges', 'insert')
      flash[:notice] = "你没有新建收费项目的权限，请联系管理员"
      render_403
      return
    end
    @charge = Charge.new(params[:charge])
    if @charge.save
      redirect_to(charges_path, :notice => '新建收费项目成功.')
    else
      render :action => "new"

    end

  end

# PUT /charges/1
# PUT /charges/1.xml
  def update
    if !@current_user.has_privilege?('charges', 'update')
      flash[:notice] = "你没有修改收费项目的权限，请联系管理员"
      render_403
      return
    end
    @charge = Charge.find(params[:id])
    if @charge.update_attributes(params[:charge])
      redirect_to(charges_path, :notice => '更新收费项目成功.')

    else
      render :action => "edit"

    end

  end

# DELETE /charges/1
# DELETE /charges/1.xml
  def destroy
    if !@current_user.has_privilege?('charges', 'destroy')
      flash[:notice] = "你没有删除收费项目的权限，请联系管理员"
      render_403
      return
    end
    @charge = Charge.find(params[:id])
    if !@charge.nil?
      @charge.destroy
    end

    redirect_to charges_path
  end

  def add_house
    if !@current_user.has_privilege?('charges', 'add_house')
      flash[:notice] = "你没有修改收费项目的权限，请联系管理员"
      render_403
      return
    end
    @charge = Charge.find(params[:id])
    if request.post?

      house_ids = params[:house_ids].split(',') || []
      @charge.houses.clear
      houses = House.find(house_ids)
      @charge.houses = houses
      if (@charge.save)
        respond_with (@charge)
      end
    end
  end

  def get_unit_price
    @charge = Charge.find(params[:id])
    render :json => @charge.to_json
  end

end

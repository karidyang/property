# -*- encoding : utf-8 -*-
#coding: utf-8
class ChargesController < ApplicationController
  before_filter :require_user
  #around_filter do |controller, action|
  #  if !@current_user.has_privilege?(controller.controller_name, controller.action_name)
  #    flash[:notice] = "你没有#{controller.controller_name}.#{controller.action_name}权限，请联系管理员"
  #    render_403
  #  else
  #    action.call
  #  end
  #end
  # GET /charges
  # GET /charges.xml
  def index
    unless @current_user.has_privilege?('charges', 'index')
      miss_privilege
      return
    end
    if params[:item_name].nil?
      @charges = Charge.where('plot_id=?', current_plot).paginate(:page => params[:page])
    else
      @charges = Charge.where('item_name like ?', "%#{params[:item_name]}%").paginate(:page => params[:page])
    end

  end

  # GET /charges/new
  # GET /charges/new.xml
  def new
    if @current_user.has_privilege?('charges', 'create')
      @charge = Charge.new
    else
      miss_privilege
    end
  end

  # GET /charges/1/edit
  def edit
    if @current_user.has_privilege?('charges', 'update')
      @charge = Charge.find(params[:id])
    else
      miss_privilege
    end
  end

  # POST /charges
  # POST /charges.xml
  def create
    if @current_user.has_privilege?('charges', 'create')
      @charge = Charge.new(params[:charge])
      if @charge.save
        redirect_to(charges_path, :notice => '新建收费项目成功.')
      else
        render :action => 'new'

      end
    else
      miss_privilege
    end

  end

# PUT /charges/1
# PUT /charges/1.xml
  def update
    if @current_user.has_privilege?('charges', 'update')
      @charge = Charge.find(params[:id])
      if @charge.update_attributes(params[:charge])
        redirect_to(charges_path, :notice => '更新收费项目成功.')

      else
        render :action => 'edit'
      end
    else
      miss_privilege
    end

  end

# DELETE /charges/1
# DELETE /charges/1.xml
  def destroy
    if @current_user.has_privilege?('charges', 'destroy')
      @charge = Charge.find(params[:id])
      if @charge
        @charge.destroy
      end

      redirect_to charges_path
    else
      miss_privilege
    end
  end

  def add_house
    if @current_user.has_privilege?('charges', 'add_house')
      @charge = Charge.find(params[:id])
      if request.post?

        house_ids = params[:house_ids].split(',') || []
        @charge.houses.clear
        houses = House.find(house_ids)
        @charge.houses = houses
        if @charge.save
          respond_with (@charge)
        end
      end
    else
      miss_privilege
    end
  end

  def get_unit_price
    @charge = Charge.find(params[:id])
    house = House.find(params[:house_id])
    if @charge.bind_area?
      @charge.price *= house.builded_area
    end
    render :json => {price: format('%#.2f', @charge.price)}
  end

end

# -*- encoding : utf-8 -*-
#coding:utf-8
class CarPortsController < ApplicationController
  before_filter :require_user

  def index
    unless @current_user.has_privilege?('carports', 'index')
      miss_privilege
      return
    end
    if params[:port_no].nil?
      @carports = CarPort.paginate(:page => params[:page])
    else
      @carports = CarPort.where('port_no like ?', "%#{params[:port_no]}%").paginate(:page => params[:page])
    end
  end

  def show

  end

  def create
    if @current_user.has_privilege?('carports', 'create')
      @carport = CarPort.new(params[:car_port])
      @carport.plot_id = session[:current_plot]
      if @carport.save
        redirect_to(car_ports_path, :notice => '新建车位成功.')
      else
        render :action => 'new'
      end
    else
      miss_privilege
    end
  end

  def new
    if @current_user.has_privilege?('carports', 'create')
      @carport = CarPort.new()
    else
      miss_privilege
    end

  end

  def edit
    if @current_user.has_privilege?('carports', 'update')
      @carport = CarPort.find(params[:id])
    else
      miss_privilege
    end

  end

  def update
    if @current_user.has_privilege?('carports', 'update')
      @carport = CarPort.find(params[:id])
      if @carport.update_attributes(params[:charge])
        redirect_to(car_ports_path, :notice => '更新收费项目成功.')

      else
        render :action => 'edit'
      end
    else
      miss_privilege
    end

  end

  def destroy
    if @current_user.has_privilege?('carports', 'destroy')
      @carport = CarPort.find(params[:id])
      if @carport && @carport.car.nil?
        @carport.destroy
      else
        flash[:notice] = "该车位还停有车辆，请先删除车辆。房号：#{@carport.car.house.house_code}, 车牌：#{@carport.car.car_no}"
      end
      redirect_to car_ports_path

    else
      miss_privilege
    end
  end
end

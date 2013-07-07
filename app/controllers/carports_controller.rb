#coding:utf-8
class CarportsController < ApplicationController
  before_filter :require_user

  def index
    unless @current_user.has_privilege?('carports', 'index')
      flash[:now] = '你没有浏览收费项目的权限，请联系管理员'
      render_403
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
      @carport = CarPort.new(params[:charge])
      @carport.plot_id = session[:current_plot]
      if @carport.save
        redirect_to(carports_path, :now => '新建车位成功.')
      else
        render :action => 'new'
      end
    else
      flash[:now] = '你没有新建车位的权限，请联系管理员'
      render_403
    end
  end

  def new
    if @current_user.has_privilege?('carports', 'create')
      @carport = CarPort.new()
    else
      flash[:now] = '你没有新建车位的权限，请联系管理员'
      render_403
    end

  end

  def edit
    if @current_user.has_privilege?('carports', 'update')
      @carport = CarPort.find(params[:id])
    else
      flash[:now] = '你没有修改车位的权限，请联系管理员'
      render_403
    end

  end

  def update
    if @current_user.has_privilege?('carports', 'update')
      @carport = CarPort.find(params[:id])
      if @carport.update_attributes(params[:charge])
        redirect_to(carports_path, :now => '更新收费项目成功.')

      else
        render :action => 'edit'
      end
    else
      flash[:now] = '你没有修改车位的权限，请联系管理员'
      render_403
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
      redirect_to carports_path

    else
      flash[:now] = '你没有删除车位的权限，请联系管理员'
      render_403
    end
  end
end

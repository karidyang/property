# coding: utf-8  
class AreasController < ApplicationController
  before_filter :require_user
  #around_filter do |controller, action|
  #  if !@current_user.has_privilege?(controller.controller_name, controller.action_name)
  #    flash[:notice] = "你没有#{controller.controller_name}.#{controller.action_name}权限，请联系管理员"
  #    render_403
  #  else
  #    action.call
  #  end
  #end
  # GET /areas
  # GET /areas.xml
  def index
    if params.has_key?('plot_id')
      @areas = Area.where('plot_id=?', params[:plot_id]).order('name').paginate(:page=>params[:page])
    else
      @areas = Area.order('name').paginate(:page=>params[:page])
    end
    respond_with (@areas)
  end

  def plot_areas
    @plot = Plot.find(params[:id])
    @areas = @plot.areas
    render :action => 'index'
  end

  # GET /areas/1
  # GET /areas/1.xml
  def show
    @area = Area.find(params[:id])
    respond_with (@area)
  end

  # GET /areas/new
  # GET /areas/new.xml
  def new
    if @current_user.has_privilege?('areas', 'insert')
      @area = Area.new
      respond_with (@area)
    else
      flash[:notice] = '你没有添加楼栋的权限，请联系管理员'
      render_403
    end
  end

  # GET /areas/1/edit
  def edit
    if @current_user.has_privilege?('areas', 'update')
      @area = Area.find(params[:id])
    else
      flash[:notice] = '你没有修改楼栋的权限，请联系管理员'
      render_403
    end
  end

  # POST /areas
  # POST /areas.xml
  def create
    if @current_user.has_privilege?('areas', 'insert')
      @area = Area.new(params[:area])
      if @area.save
        redirect_to(area_path, :notice => 'Area was successfully created.')

      else
        render :action => 'new'

      end
    else
      flash[:notice] = '你没有添加楼栋的权限，请联系管理员'
      render_403
    end

  end

  # PUT /areas/1
  # PUT /areas/1.xml
  def update
    if @current_user.has_privilege?('areas', 'update')
      @area = Area.find(params[:id])
      if @area.update_attributes(params[:area])
        redirect_to(area_path, :notice => 'Area was successfully updated.')

      else
        render :action => 'edit'

      end
    else
      flash[:notice] = '你没有修改楼栋的权限，请联系管理员'
      render_403

    end

  end

  # DELETE /areas/1
  # DELETE /areas/1.xml
  def destroy
    if @current_user.has_privilege?('areas', 'destroy')
      @area = Area.find(params[:id])
      if @area
        @area.destroy
      end
      redirect_to area_path
    else

      flash[:notice] = '你没有删除楼栋的权限，请联系管理员'
      render_403
    end
  end
end

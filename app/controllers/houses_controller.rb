# coding: utf-8  
class HousesController < ApplicationController
  before_filter :require_user
  around_filter do |controller, action|
    if !@current_user.has_privilege?(controller.controller_name, controller.action_name)
      flash[:notice] = "你没有#{controller.controller_name}.#{controller.action_name}权限，请联系管理员"
      render_403
    else
      action.call
    end
  end
  # GET /houses
  # GET /houses.xml
  def index

    if params.has_key?(:plot_id)
      @house_code = params[:house_code]
      if @house_code != ''
        @houses = House.where("plot_id=? and house_code=?", params[:plot_id], @house_code).order('house_code').page params[:page]
      else
        @houses = House.where("plot_id=?", params[:plot_id]).order('house_code').page params[:page]
      end
    else
      @houses = House.order('house_code').page params[:page]
    end

  end

  # GET /houses/1
  # GET /houses/1.xml
  def show
    @house = House.find(params[:id])
  end

  # GET /houses/new
  # GET /houses/new.xml
  def new
    if !@current_user.has_privilege?('houses', 'insert')
      flash[:notice] = '您没有新增房间的权限,请联系管理员'
      render_403
      return
    end
    @house = House.new
  end

  # GET /houses/1/edit
  def edit
    if !@current_user.has_privilege?('houses', 'update')
      flash[:notice] = '您没有编辑房间的权限,请联系管理员'
      render_403
      return
    end
    @house = House.find(params[:id])
  end

  # POST /houses
  # POST /houses.xml
  def create
    if !@current_user.has_privilege?('houses', 'insert')
      flash[:notice] = '您没有新增房间的权限,请联系管理员'
      render_403
    end
    @house = House.new(params[:house])
    @area = @house.area
    @house.plot = @area.plot

    if @house.save
      redirect_to(houses_url, :notice => '新建房间成功.')

    else
      render :action => "new"

    end

  end

  # PUT /houses/1
  # PUT /houses/1.xml
  def update
    if !@current_user.has_privilege?('houses', 'update')
      flash[:notice] = '您没有编辑房间的权限,请联系管理员'
      render_403
      return
    end
    @house = House.find(params[:id])


    if @house.update_attributes(params[:house])
      redirect_to(houses_url, :notice => '更新房间成功.')

    else
      render :action => "edit"

    end

  end

  # DELETE /houses/1
  # DELETE /houses/1.xml
  def destroy
    if !@current_user.has_privilege?('houses', 'destroy')
      flash[:notice] = '您没有删除房间的权限,请联系管理员'
      render_403
      return
    end
    @house = House.find(params[:id])
    if !@house.nil?
      @house.destroy
    end
    redirect_to(houses_url)
  end

  def house_tree
    if !@current_user.has_privilege?('houses', 'select')
      render :json => "[]"
    end
    @plots = @current_user.plots
    json = []
    @plots.each { |plot| json << plot.to_json }

    render :json => "[#{json.join(',')}]"

  end

  def house_info
    house_code = params[:house_code]

  end

end

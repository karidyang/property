# coding: utf-8  
class OwnersController < ApplicationController
  before_filter :require_user
  #around_filter do |controller, action|
  #  if !@current_user.has_privilege?(controller.controller_name, controller.action_name)
  #    flash[:notice] = "你没有#{controller.controller_name}.#{controller.action_name}权限，请联系管理员"
  #    render_403
  #  else
  #    action.call
  #  end
  #end
  # GET /owners
  # GET /owners.xml
  def index
    if params.has_key?('house_code')
      @house_code = params[:house_code]
      house = House.find_by_house_code(@house_code)
      @owners = house.owners.order('name')
    else
      @house_code = 0
      @owners = Owner.order('house_id').paginate(:page=>params[:page])
    end

  end

  # GET /owners/1
  # GET /owners/1.xml
  def show
    @owner = Owner.find(params[:id])

  end

  # GET /owners/new
  # GET /owners/new.xml
  def new
    @owner = Owner.new
    @owner.house_id = params[:house_id]

  end

  # GET /owners/1/edit
  def edit
    @owner = Owner.find(params[:id])
  end

  # POST /owners
  # POST /owners.xml
  def create
    pt = params[:owner]
    @owner = Owner.new(pt)
    @owner.house_id = params[:house] || pt[:house_id]
    if @owner.save
      @house = @owner.house
      @house.owner_name = @owner.name
      @house.receive_time = Date.today
      @house.save
      redirect_to({:controller=>:houses,:action=>:index, :plot_id=>@house.plot_id,:house_code=>@house.house_code}, :notice => '添加业主成功')
    else
      render :action => 'new'
    end
  end

  # PUT /owners/1
  # PUT /owners/1.xml
  def update

    @owner = Owner.find(params[:id])
    @owner.house.owner_name = @owner.name
    if @owner.update_attributes(params[:owner])
      redirect_to(owners_url, :notice => '更新业主信息成功')
    else
      render :action => 'edit'
    end
  end

  # DELETE /owners/1
  # DELETE /owners/1.xml
  def destroy
    @owner = Owner.find(params[:id])
    if owner
      @house = @owner.house
      @house.owner_name = nil
      @house.save
      @owner.destroy
    end
    redirect_to houses_path
  end
end

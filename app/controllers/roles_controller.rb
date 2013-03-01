# coding: utf-8  
class RolesController < ApplicationController
  before_filter :require_user
  #around_filter do |controller, action|
  #  if !@current_user.has_privilege?(controller.controller_name, controller.action_name)
  #    flash[:notice] = "你没有#{controller.controller_name}.#{controller.action_name}权限，请联系管理员"
  #    render_403
  #  else
  #    action.call
  #  end
  #end
  # GET /roles
  # GET /roles.xml
  def index
    @roles = Role.order('name').paginate(:page=>params[:page])
  end

  # GET /roles/1
  # GET /roles/1.xml
  def show
    @role = Role.find(params[:id])
  end

  # GET /roles/new
  # GET /roles/new.xml
  def new
    @role = Role.new
  end

  # GET /roles/1/edit
  def edit
    @role = Role.find(params[:id])
  end

  # POST /roles
  # POST /roles.xml
  def create
    @role = Role.new(params[:role])


    if @role.save
      redirect_to(roles_url, :notice => '新建角色成功.')

    else
      render :action => 'new'

    end

  end

  # PUT /roles/1
  # PUT /roles/1.xml
  def update
    @role = Role.find(params[:id])


    if @role.update_attributes(params[:role])
      redirect_to(roles_url, :notice => '角色保存成功.')

    else
      render :action => 'edit'

    end

  end

  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    @role = Role.find(params[:id])
    @role.destroy
    respond_with(@role, :location=>:back)
  end
end

# coding: utf-8  
class RolesController < ApplicationController
  before_filter :require_user
  layout 'admin'
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
    if !@current_user.has_privilege?('roles', 'index')
      flash[:now] = '你没有浏览角色的权限，请联系管理员'
      render_403
      return
    end

    @roles = Role.order('name').paginate(:page => params[:page])
    render 'admin/roles/index'
  end


  # GET /roles/new
  # GET /roles/new.xml
  def new
    if !@current_user.has_privilege?('roles', 'create')
      flash[:now] = '你没有增加角色的权限，请联系管理员'
      render_403
      return
    end
    @role = Role.new
    @privileges = Privilege.all
    render 'admin/roles/new'
  end

  # GET /roles/1/edit
  def edit
    if !@current_user.has_privilege?('roles', 'update')
      flash[:now] = '你没有修改角色的权限，请联系管理员'
      render_403
      return
    end
    @role = Role.find(params[:id])
    render 'admin/roles/edit'
  end

  # POST /roles
  # POST /roles.xml
  def create
    if !@current_user.has_privilege?('roles', 'create')
      flash[:now] = '你没有增加角色的权限，请联系管理员'
      render_403
      return
    end
    @role = Role.new(params[:role])

    if @role.save
      params[:role][:privilege_ids] ||= []
      if @role.update_attributes(params[:role])
        redirect_to(roles_url, :now => '新建角色成功.')
      else
        render 'admin/roles/new'
      end
    else
      render 'admin/roles/new'
    end
  end

  # PUT /roles/1
  # PUT /roles/1.xml
  def update
    if !@current_user.has_privilege?('roles', 'update')
      flash[:now] = '你没有修改角色的权限，请联系管理员'
      render_403
      return
    end
    @role = Role.find(params[:id])


    if @role.update_attributes(params[:role])
      redirect_to(roles_url, :now => '角色保存成功.')

    else
      render 'admin/roles/edit'
    end

  end

  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    if !@current_user.has_privilege?('roles', 'destroy')
      flash[:now] = '你没有删除角色的权限，请联系管理员'
      render_403
      return
    end
    @role = Role.find(params[:id])
    if @role.destroy
      flash[:now] = '删除成功'
    else
      flash[:now] = '删除失败'
    end
    redirect_to roles_path
  end
end

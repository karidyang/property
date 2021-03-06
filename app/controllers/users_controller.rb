# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  before_filter :require_user, :except => [:new, :create]
  layout('admin')
  # GET /users
  # GET /users.xml
  def index
    unless @current_user.has_privilege?('users', 'index')
      flash.now[:error] = '你没有浏览用户的权限，请联系管理员'
      render_403
      return
    end
    if params.has_key?('name')
      @users = User.where('name like ? and company_id=?', "%#{params[:name]}%", current_user.company_id).paginate(:page => params[:page])
    else
      @users = User.where('company_id=?', current_user.company_id).paginate(:page => params[:page])
    end
    render 'admin/users/index'
  end


  # GET /users/new
  # GET /users/new.xml
  def new
    unless @current_user.has_privilege?('users', 'create')
      flash.now[:error] = '你没有增加用户的权限，请联系管理员'
      render_403
      return
    end
    @user = User.new
    render 'admin/users/new'
  end

  # GET /users/1/edit
  def edit
    unless @current_user.has_privilege?('users', 'update')
      flash.now[:error] = '你没有更新用户的权限，请联系管理员'
      render_403
      return
    end
    @user = @current_user
    render 'admin/users/edit'
  end

  # POST /users
  # POST /users.xml
  def create
    unless @current_user.has_privilege?('users', 'create')
      flash.now[:error] = '你没有增加用户的权限，请联系管理员'
      render_403
      return
    end
    @user = User.new(params[:user])
    @user.company_id = @current_user.company_id
    if @user.save
      flash.now[:error] = '注册成功.'
      redirect_back_or_default user_path
    else
      render 'admin/users/new'
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    unless @current_user.has_privilege?('users', 'update')
      flash.now[:error] = '你没有更新用户的权限，请联系管理员'
      render_403
      return
    end
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to(@user, :notice => '保存用户成功.')

    else
      render :action => 'edit'

    end

  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    unless @current_user.has_privilege?('users', 'destroy')
      flash.now[:error] = '你没有删除用户的权限，请联系管理员'
      render_403
      return
    end
    @user = User.find(params[:id])
    @user.destroy
    respond_with(@user, :location => :back)
  end

  def add_role
    unless @current_user.has_privilege?('users', 'add_role')
      flash.now[:error] = '你没有绑定用户角色的权限，请联系管理员'
      render_403
      return
    end
    @user = User.find(params[:id])
    if request.post?
      if params.include?(:user)
        params[:user][:role_ids] ||= []
        if @user.update_attributes(params[:user])
          flash[:notice] = '用户角色保存成功.'
          redirect_to users_path
        end
      else
        @user.roles = []
        if @user.save!
          flash[:notice] = '用户角色保存成功.'
          redirect_to users_path
        end
      end
    else
      @roles = get_roles
      render 'admin/users/add_role'
    end

  end

  def add_plot
    unless @current_user.has_privilege?('users', 'add_plot')
      flash.now[:notice] = '你没有绑定用户小区的权限，请联系管理员'
      render_403
      return
    end
    @user = User.find(params[:id])
    if request.post?
      if params.include?(:user)
        params[:user][:plot_ids] ||= []
        if @user.update_attributes(params[:user])
          flash.now[:error] = '用户小区保存成功.'
          redirect_to users_path
        end
      else
        @user.roles = []
        if @user.save!
          flash[:notice] = '用户小区保存成功.'
          redirect_to users_path
        end
      end
    else
      @plots = Plot.all
      render 'admin/users/add_plot'
    end
  end

  private
  def get_roles
    @roles = Role.all
  end
end

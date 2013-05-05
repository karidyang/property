# coding: utf-8
class UsersController < ApplicationController
  before_filter :require_user, :except => [:new, :create]
  layout('admin')
  # GET /users
  # GET /users.xml
  def index
    if !@current_user.has_privilege?('users', 'index')
      flash[:now] = '你没有浏览用户的权限，请联系管理员'
      render_403
      return
    end
    if params.has_key?('name')
      @users = User.where('name like ?', "%#{params[:name]}%").paginate(:page => params[:page])
    else
      @users = User.paginate(:page => params[:page])
    end
    render 'admin/users/index'
  end


  # GET /users/new
  # GET /users/new.xml
  def new
    if !@current_user.has_privilege?('users', 'create')
      flash[:now] = '你没有增加用户的权限，请联系管理员'
      render_403
      return
    end
    @user = User.new
    render 'admin/users/new'
  end

  # GET /users/1/edit
  def edit
    if !@current_user.has_privilege?('users', 'update')
      flash[:now] = '你没有更新用户的权限，请联系管理员'
      render_403
      return
    end
    @user = @current_user
    render 'admin/users/edit'
  end

  # POST /users
  # POST /users.xml
  def create
    if !@current_user.has_privilege?('users', 'create')
      flash[:now] = '你没有增加用户的权限，请联系管理员'
      render_403
      return
    end
    @user = User.new(params[:user])

    if @user.save
      flash[:now] = '注册成功.'
      redirect_back_or_default user_path
    else
      render 'admin/users/new'
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    if !@current_user.has_privilege?('users', 'update')
      flash[:now] = '你没有更新用户的权限，请联系管理员'
      render_403
      return
    end
    @user = User.find(params[:id])


    if @user.update_attributes(params[:user])
      redirect_to(@user, :now => '保存用户成功.')

    else
      render :action => 'edit'

    end

  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    if !@current_user.has_privilege?('users', 'destroy')
      flash[:now] = '你没有删除用户的权限，请联系管理员'
      render_403
      return
    end
    @user = User.find(params[:id])
    @user.destroy
    respond_with(@user, :location => :back)
  end

  def add_role
    if !@current_user.has_privilege?('users', 'add_role')
      flash[:now] = '你没有绑定用户角色的权限，请联系管理员'
      render_403
      return
    end
    @user = User.find(params[:id])
    if request.post?
      if params.include?(:user)
        params[:user][:role_ids] ||= []
        if @user.update_attributes(params[:user])
          flash[:now] = '用户角色保存成功.'
          redirect_to users_path
        end
      else
        @user.roles = []
        if @user.save!
          flash[:now] = '用户角色保存成功.'
          redirect_to users_path
        end
      end
    else
      @roles = get_roles
      render 'admin/users/add_role'
    end

  end

  def add_plot
    if !@current_user.has_privilege?('users', 'add_plot')
      flash[:now] = '你没有绑定用户小区的权限，请联系管理员'
      render_403
      return
    end
    @user = User.find(params[:id])
    if request.post?
      if params.include?(:user)
        params[:user][:plot_ids] ||= []
        if @user.update_attributes(params[:user])
          flash[:now] = '用户小区保存成功.'
          redirect_to users_path
        end
      else
        @user.roles = []
        if @user.save!
          flash[:now] = '用户小区保存成功.'
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

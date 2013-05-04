# coding: utf-8
class UsersController < ApplicationController
  before_filter :require_user, :except => [:new, :create]
  layout('admin')
  # GET /users
  # GET /users.xml
  def index
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
    @user = User.new
    render 'admin/users/new'
  end

  # GET /users/1/edit
  def edit
    @user = @current_user
    render 'admin/users/edit'
  end

  # POST /users
  # POST /users.xml
  def create

    @user = User.new(params[:user])

    if @user.save
      flash[:notice] = '注册成功.'
      redirect_back_or_default user_path
    else
      render 'admin/users/new'
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
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
    @user = User.find(params[:id])
    @user.destroy
    respond_with(@user, :location => :back)
  end

  def add_role
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
    @user = User.find(params[:id])
    if request.post?
      if params.include?(:user)
        params[:user][:plot_ids] ||= []
        if @user.update_attributes(params[:user])
          flash[:notice] = '用户小区保存成功.'
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

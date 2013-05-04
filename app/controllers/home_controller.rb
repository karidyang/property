# coding: utf-8  
class HomeController < ApplicationController

  def index
    if @current_user.nil?
      redirect_to :action => :login
    end
  end

  def demo
  end

  def login
    @user_session = UserSession.new
    render :layout => false
  end

  def login_create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save

      redirect_to :action => :choose_plot
    else
      render :layout => false, :action => :login
    end
  end

  def logout
    current_user_session.destroy
    redirect_to login_path
  end

  def choose_plot
    if params[:current_plot]
      session[:current_plot] = params[:current_plot].to_i
      session[:current_plot_name] = Plot.find(session[:current_plot]).name
      redirect_to root_path
    else
      render :layout => false, :action => :choose_plot
    end
  end

  def list
    @houses = House.all
    rows = []
    json = Hash.new
    @houses.each do |house|
      h_json = {:id => house.id, :name => house.house_code}
      rows << h_json
    end
    json['total'] = @houses.length
    json['rows'] = rows
    render :json => json.to_json
  end

  def profile
    @user = current_user
    if request.post?
      @user.old_password = params[:old_password]
      if @user.validate_old_password && @user.update_attributes(params[:user])
        flash[:notice] = "密码修改成功！"
        redirect_to root_path
      else
        flash[:error] = "旧密码不正确"
        render 'user_profile'
      end

    else
      render 'user_profile'
    end
  end

end

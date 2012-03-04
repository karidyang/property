# coding: utf-8  
class HomeController < ApplicationController

  def index
    if @current_user.nil?
      redirect_to :action => :login
    end
  end

  def demo
    render :layout => nil
  end

  def login
    @user_session = UserSession.new
    render :layout => false
  end

  def login_create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save

      render :action => :choose_plot
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
      redirect_to root_path
    else
      render :choose_plot
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
end

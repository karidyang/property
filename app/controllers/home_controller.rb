# coding: utf-8  
class HomeController < ApplicationController

  def index
    @house = House.first
  end

  def login
    @user_session = UserSession.new
    render :layout=>false
  end

  def login_create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_back_or_default root_path
    else
      render :action => :login
    end
  end

  def logout
    current_user_session.destroy
    redirect_back_or_default root_path
  end
end

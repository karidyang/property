# coding: utf-8  
class HomeController < ApplicationController

  def index
    
  end

  def demo
    render :layout => nil
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
  def list
    @houses = House.all
    rows = []
    json = Hash.new
    @houses.each do |house|
      h_json = {"id"=>house.id,"name"=>house.house_code}
      rows << h_json
    end
    json['total'] = @houses.length
    json['rows'] = rows
    render :json => json.to_json
  end
end

# -*- encoding : utf-8 -*-
#coding:utf-8
class CarsController < ApplicationController
  before_filter :require_user
  before_filter :require_plot

  def create
    @car = Car.new(params[:car])
    house = House.find(params[:house_id])
    @car.house = house
    if @car.save
      redirect_to controller: 'home', action: 'index', id: house.id
    else
      flash[:notice] = '新增车辆信息失败'
      render 'new'
    end

  end

  def new
    @car = Car.new
    @house = House.find(params[:house_id])
  end

  def edit
    @car = Car.find(params[:id])
  end

  def destroy
    @car = Car.find(params[:id])
    if @car
      @car.destroy

    end
    redirect_to root_path
  end

end

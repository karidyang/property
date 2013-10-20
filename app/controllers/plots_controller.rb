# -*- encoding : utf-8 -*-
class PlotsController < ApplicationController
  before_filter :require_user
  #around_filter do |controller, action|
  #  if !@current_user.has_privilege?(controller.controller_name, controller.action_name)
  #    flash[:notice] = "你没有#{controller.controller_name}.#{controller.action_name}权限，请联系管理员"
  #    render_403
  #  else
  #    action.call
  #  end
  #end
  # GET /plots
  # GET /plots.xml
  def index
    @plots = Plot.all
  end

  # GET /plots/1
  # GET /plots/1.xml
  def show
    @plot = Plot.find(params[:id])
  end

  # GET /plots/new
  # GET /plots/new.xml
  def new
    @plot = Plot.new
  end

  # GET /plots/1/edit
  def edit
    @plot = Plot.find(params[:id])
  end

  # POST /plots
  # POST /plots.xml
  def create
    @plot = Plot.new(params[:plot])


    if @plot.save
      redirect_to(@plot, :notice => 'Plot was successfully created.')

    else
      render :action => 'new'

    end

  end

  # PUT /plots/1
  # PUT /plots/1.xml
  def update
    @plot = Plot.find(params[:id])


    if @plot.update_attributes(params[:plot])
      redirect_to(@plot, :notice => 'Plot was successfully updated.')

    else
      render :action => 'edit'

    end

  end

  # DELETE /plots/1
  # DELETE /plots/1.xml
  def destroy
    @plot = Plot.find(params[:id])
    @plot.destroy
    respond_with(@plot, :location => :back)
  end
end

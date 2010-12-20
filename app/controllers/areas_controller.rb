# coding: utf-8  
class AreasController < ApplicationController
  # GET /areas
  # GET /areas.xml
  def index
    if params.has_key?('plot_id')
      @areas = Area.where("plot_id=?",params[:plot_id]).order('name').paginate(:page=>params[:page])
    else
      @areas = Area.order('name').paginate(:per_page => 10, :page => params[:page])
    end
    respond_with (@areas)
  end

  def plot_areas
    @plot  = Plot.find(params[:id])
    @areas = @plot.areas
    render :action => "index"
  end

  # GET /areas/1
  # GET /areas/1.xml
  def show
    @area = Area.find(params[:id])
    respond_with (@area)
  end

  # GET /areas/new
  # GET /areas/new.xml
  def new
    @area = Area.new
    respond_with (@area)
  end

  # GET /areas/1/edit
  def edit
    @area = Area.find(params[:id])
  end

  # POST /areas
  # POST /areas.xml
  def create
    @area = Area.new(params[:area])

    respond_to do |format|
      if @area.save
        format.html { redirect_to(@area, :notice => 'Area was successfully created.') }
        format.xml { render :xml => @area, :status => :created, :location => @area }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @area.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /areas/1
  # PUT /areas/1.xml
  def update
    @area = Area.find(params[:id])

    respond_to do |format|
      if @area.update_attributes(params[:area])
        format.html { redirect_to(@area, :notice => 'Area was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @area.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /areas/1
  # DELETE /areas/1.xml
  def destroy
    @area = Area.find(params[:id])
    @area.destroy
    respond_with(@area,:location=>:back)
  end
end

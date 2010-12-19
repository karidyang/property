# coding: utf-8  
class HousesController < ApplicationController
  # GET /houses
  # GET /houses.xml
  def index
    if params.has_key?('plot_id')
      @houses = House.where("plot_id=?",params[:plot_id]).order('house_code').paginate :page=>params[:page], :per_page=>5
    else
      @houses = House.order('house_code').paginate :page=>params[:page], :per_page=>5
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @houses }
    end
  end

  # GET /houses/1
  # GET /houses/1.xml
  def show
    @house = House.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @house }
    end
  end

  # GET /houses/new
  # GET /houses/new.xml
  def new
    @house = House.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @house }
    end
  end

  # GET /houses/1/edit
  def edit
    @house = House.find(params[:id])
  end

  # POST /houses
  # POST /houses.xml
  def create
    @house      = House.new(params[:house])
    @area       = @house.area
    @house.plot = @area.plot
    respond_to do |format|
      if @house.save
        format.html { redirect_to(houses_url, :notice => '新建房间成功.') }
        format.xml { render :xml => @house, :status => :created, :location => @house }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @house.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /houses/1
  # PUT /houses/1.xml
  def update
    @house = House.find(params[:id])

    respond_to do |format|
      if @house.update_attributes(params[:house])
        format.html { redirect_to(houses_url, :notice => '更新房间成功.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @house.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /houses/1
  # DELETE /houses/1.xml
  def destroy
    @house = House.find(params[:id])
    @house.destroy

    respond_to do |format|
      format.html { redirect_to(houses_url) }
      format.xml { head :ok }
    end
  end

  def house_tree
    type   = params[:type].to_i
    treeid = params[:treeid].to_i
    #house_code = params[:house_code]
    #type==0取小区, type=2取房间
    case type
      when 0
        json = []
#            Plot.find(:all).each do |plot|
        json << Plot.first.to_json
#            end
        render :json => "[#{json.join(",")}]"
      when 2
        area = Area.find(treeid)
        render :json => area.houses_json
    end

  end
end

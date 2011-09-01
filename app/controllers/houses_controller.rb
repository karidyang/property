# coding: utf-8  
class HousesController < ApplicationController
  before_filter :require_user
  # GET /houses
  # GET /houses.xml
  def index
    if !@current_user.has_privilege?('house', 'select')
      render_403
      return
    end
    if params.has_key?('plot_id')
      @houses = House.where("plot_id=?", params[:plot_id]).order('house_code').paginate :page=>params[:page], :per_page=>5
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
    if !@current_user.has_privilege?('house', 'insert')
      render_403
      return
    end
    @house = House.new

    respond_to do |format|
      format.html # add_pre_money.html.erb
      format.xml { render :xml => @house }
    end
  end

  # GET /houses/1/edit
  def edit
    if !@current_user.has_privilege?('house', 'update')
      render_403
      return
    end
    @house = House.find(params[:id])
  end

  # POST /houses
  # POST /houses.xml
  def create
    if !@current_user.has_privilege?('house', 'insert')
      render_403
    end
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
    if !@current_user.has_privilege?('house', 'update')
      render_403
      return
    end
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
    if !@current_user.has_privilege?('house', 'delete')
      render_403
      return
    end
    @house = House.find(params[:id])
    @house.destroy
    respond_with(@house, :location=>:back)
  end

  def house_tree
    if !@current_user.has_privilege?('house', 'select')
      render :json => "[]"
    end
    @plots = Plot.all
    json = []
    @plots.each { |plot| json << plot.to_json }

    render :json => "[#{json.join(',')}]"

  end

end

#coding: utf-8
class ChargesController < ApplicationController
  before_filter :require_user
  # GET /charges
  # GET /charges.xml
  def index
    @charges = Charge.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @charges }
    end
  end

  # GET /charges/1
  # GET /charges/1.xml
  def show
    @charge = Charge.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @charge }
    end
  end

  # GET /charges/new
  # GET /charges/new.xml
  def new
    @charge = Charge.new

    respond_to do |format|
      format.html # add_pre_money.html.erb
      format.xml  { render :xml => @charge }
    end
  end

  # GET /charges/1/edit
  def edit
    @charge = Charge.find(params[:id])
  end

  # POST /charges
  # POST /charges.xml
  def create
    @charge = Charge.new(params[:charge])

    respond_to do |format|
      if @charge.save
        format.html { redirect_to(@charge, :notice => 'Charge was successfully created.') }
        format.xml  { render :xml => @charge, :status => :created, :location => @charge }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @charge.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /charges/1
  # PUT /charges/1.xml
  def update
    @charge = Charge.find(params[:id])

    respond_to do |format|
      if @charge.update_attributes(params[:charge])
        format.html { redirect_to(@charge, :notice => 'Charge was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @charge.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /charges/1
  # DELETE /charges/1.xml
  def destroy
    @charge = Charge.find(params[:id])
    @charge.destroy
    respond_with(@charge,:location=>:back)
  end

  def add_house
    @charge = Charge.find(params[:id])
    if request.post?

      house_ids = params[:house_ids].split(',') || []
      @charge.houses.clear
      houses = House.find(house_ids)
      @charge.houses = houses
      if(@charge.save)
        respond_with (@charge)
      end
    end
  end

  def get_unit_price
    @charge = Charge.find(params[:id])
    render :json => @charge.to_json
  end
end

# coding: utf-8  
class OwnersController < ApplicationController
  # GET /owners
  # GET /owners.xml
  def index
    if params.has_key?('house_code')
      @house_code = params[:house_code]
      house       = House.find_by_house_code(@house_code)
      @owners     = WillPaginate::Collection.create(1, 10) do |pager|
        pager.replace(house.owners)
        unless pager.total_entries
          # the pager didn't manage to guess the total count, do it manually
          pager.total_entries = house.owners.size
        end

      end
    else
      @house_code = 0
      @owners     = Owner.paginate :page=>params[:page], :order=>'house_id'
    end

  end

  # GET /owners/1
  # GET /owners/1.xml
  def show
    @owner = Owner.find(params[:id])

  end

  # GET /owners/new
  # GET /owners/new.xml
  def new
    @owner          = Owner.new
    @owner.house_id = params[:house_id]

  end

  # GET /owners/1/edit
  def edit
    @owner = Owner.find(params[:id])
  end

  # POST /owners
  # POST /owners.xml
  def create
    pt                      = params[:owner]
    @owner                  = Owner.new(pt)
    @owner.house_id         = params[:house] || pt[:house_id]
    if @owner.save
      @house = @owner.house
      @house.owner_name = @owner.name
      @house.save
      redirect_to(owners_url, :notice => 'Owner was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /owners/1
  # PUT /owners/1.xml
  def update

    @owner                  = Owner.find(params[:id])
    @owner.house.owner_name = @owner.name
    if @owner.update_attributes(params[:owner])
      redirect_to(owners_url, :notice => 'Owner was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /owners/1
  # DELETE /owners/1.xml
  def destroy
    @owner = Owner.find(params[:id])
    @house = @owner.house
    @house.owner_name = nil
    @house.save
    @owner.destroy
    respond_with(@owner,:location=>:back)
  end
end

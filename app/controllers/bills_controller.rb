# coding: utf-8 
class BillsController < ApplicationController
  before_filter :require_user
  before_filter :require_plot
  #around_filter do |controller, action|
  #  if !@current_user.has_privilege?(controller.controller_name, controller.action_name)
  #    flash[:notice] = "你没有#{controller.controller_name}.#{controller.action_name}权限，请联系管理员"
  #    render_403
  #  else
  #    action.call
  #  end
  #end
  # GET /bills
  # GET /bills.json
  def index
    if params[:house_code]
      house = House.where("plot_id=? and house_code=?",current_plot,params[:house_code]).first
      @bills = house.bills.page params[:page]
    else
      @bills = Bill.find_all_by_plot_id(current_plot).page params[:page]
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bills }
    end
  end

  # GET /bills/1/edit
  def edit
    @bill = Bill.find(params[:id])
  end


  # PUT /bills/1
  # PUT /bills/1.json
  def update
    @bill = Bill.find(params[:id])

    respond_to do |format|
      if @bill.update_attributes(params[:bill])
        format.html { redirect_to @bill, notice: 'Bill was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1
  # DELETE /bills/1.json
  def destroy
    @bill = Bill.find(params[:id])
    @bill.destroy

    respond_to do |format|
      format.html { redirect_to bills_url }
      format.json { head :ok }
    end
  end

  def calculate

    plot = Plot.find(current_plot)
    plot.areas.each do |area|
      area.houses.each do |house|
        house.create_bill(Date.today, @current_user.name)
      end
    end
    redirect_to :action => :index
  end
end

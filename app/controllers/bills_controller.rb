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

  def search
    house = House.where("plot_id=? and house_code=?", current_plot, params[:house_code]).first
    bill_items = BillItem.where("house_id=? and status = ? and trans_time between ? and ?", house.id, params[:charge_type], params[:start_time], params[:end_time])
    bill_items_json = []
    bill_items.each do |bill_item|
      bill_items_json << bill_item.json
    end  
    render :json => {bill_items:bill_items_json}
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

  def pay

    bill_item_ids = params[:bill_item_ids].each{|itemId| itemId.to_i}

    if bill_item_ids.empty?
      result = {:result=>'fail',:msg=>'数组为空'}
    else
      house = House.find(params[:house_id])
      bill_items = BillItem.find(bill_item_ids)
      bill_items.each do |bi|
        bi.pay(@current_user.name)
        bi.bill.check_status
      end
      result = {:result => 'success',:msg => '缴费成功',:house_code => house.house_code}
    end
    render :json => result

  end

  def reset

    bill_item_ids = params[:bill_item_ids].each{|itemId| itemId.to_i}

    if bill_item_ids.empty?
      result = {:result=>'fail',:msg=>'数组为空'}
    else
      house = House.find(params[:house_id])
      bill_items = BillItem.find(bill_item_ids)
      bill_items.each do |bi|
        bi.reset(@current_user.name)
        bi.bill.check_status
      end
      result = {:result => 'success',:msg => '重置成功',:house_code => house.house_code}
    end
    render :json => result

  end

  def push
    bill_item_ids = params[:bill_item_ids].each {|itemId| itemId.to_i}
      
    if bill_item_ids.empty?
      result = {:result=>'fail',:msg=>'数组为空'}
    else
      house = House.find(params[:house_id])
      bill_items = BillItem.find(bill_item_ids)
      bill_items.each do |bi|
        bi.push_item true, @current_user.name
        bi.bill.check_status
      end
      result = {:result => 'success',:msg => '冲销成功',:house_code => house.house_code}
    end
    render :json => result
  end

  def show 
    bill = Bill.find(params[:bill_id])
    json = []
    bill.bill_items.each do |item|
      json << item.json
    end
    render :json => {:total=>1,:rows=>json}
  end
end

# -*- encoding : utf-8 -*-
#coding:utf-8
class ReceiptController < ApplicationController
  def show
    unless @current_user.has_privilege?('receipts', 'show')
      miss_privilege
      return
    end
    @receipt = Receipt.find_by_receipt_no(params[:receipt_no])
    @receipt.init_info
    render :layout => nil
  end

  #打印收费单据
  def print
    unless @current_user.has_privilege?('receipts', 'print')
      miss_privilege
      return
    end
    type = params[:type].to_i
    item_ids = params[:item_ids].each { |id| id.to_i }

    items = BillItem.find(item_ids)
    @receipt = nil
    items.each { |item| @receipt = item.receipt if item.receipt }
    #puts "@receipt=>#{@receipt}"
    if @receipt.nil?
      @receipt = Receipt.new
    end
    items.each do |item|
      if item.receipt.nil?
        #puts "item #{item.item_name} has receipt #{item.receipt_no}"
        @receipt.add_item(item, @current_user.name)
      end
    end
    @receipt.save
    @receipt.init_info
    render :layout => nil


  end

  def print_account
    unless @current_user.has_privilege?('receipts', 'print_account')
      miss_privilege
      return
    end
    type = params[:type].to_i
    item_ids = params[:item_ids].each { |id| id.to_i }
    items = AccountDetail.find(item_ids)
    @receipt = nil
    items.each { |item| @receipt = item.receipt if item.receipt }
    #puts "@receipt=>#{@receipt}"
    if @receipt.nil?
      @receipt = Receipt.new
    end
    items.each do |item|
      if item.receipt.nil?
        @receipt.add_account_item(item, @current_user.name)
      end
    end
    @receipt.save
    @receipt.init_info

    render :layout => nil
  end

  def unpay_list
    unless @current_user.has_privilege?('receipts', 'unpay_list')
      miss_privilege
      return
    end
    plot_id = params[:plot_id] || session[:current_plot]
    @areas = Area.find_all_by_plot_id(plot_id)
    if params[:area_id]
      area = Area.find(params[:area_id])
      @houses = area.houses.paginate(:page => params[:page])
    else
      area = @areas.first
      @houses = area.houses.paginate(:page => params[:page])
    end
    @total_unpay_money = 0
    @houses.each { |h| @total_unpay_money += h.total_unpay_money }
    @area_id = area.id
  end

  def print_unpay
    unless @current_user.has_privilege?('receipts', 'print_unpay')
      miss_privilege
      return
    end
    @receipts = []
    house_ids = params[:house_ids]
    House.find(house_ids).each do |house|
      unpay = house.unpay
      @receipts << unpay
    end
    render :layout => nil
  end
end

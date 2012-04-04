#coding:utf-8
class ReceiptController < ApplicationController
  def show
  end

  #打印收费单据
  def print
    type = params[:type].to_i
    item_ids = params[:item_ids].each {|id| id.to_i}

    if type == 0
      items = BillItem.find(item_ids)
      @receipt = nil
      items.each {|item| @receipt = item.receipt if item.receipt}
      puts "@receipt=>#{@receipt}"
      if @receipt.nil?
        @receipt = Receipt.new
      end
      items.each do |item|
        if item.receipt.nil?
          @receipt.add_item(item)
        end
      end
    end
    @receipt.save
    @receipt.init_info
    render :layout => nil
  end

end

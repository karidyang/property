#coding:utf-8
class ReceiptController < ApplicationController
  def show
  end

  #打印收费单据
  def print
    receipt = Receipt.new
    type = params[:type]

  end

end

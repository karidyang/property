# -*- encoding : utf-8 -*-
#coding:utf-8
class Receipt < ActiveRecord::Base
  has_many :details, :class_name => 'BillItem', :order => 'trans_time desc'
  has_many :account_details, :class_name => 'AccountDetail', :order => 'trans_time'
  belongs_to :plot
  belongs_to :house
  before_create :create_no
  attr_accessor :company_info, :house_info, :phone


  def create_no
    self.receipt_no = Time.now.strftime('%Y%m%d%H%M%S') if self.receipt_no.nil?
  end


  def add_item(bill_item, operator='系统')

    self.house = House.find(bill_item.house_id) if self.house.nil?
    self.plot = Plot.find(bill_item.plot_id) if self.plot.nil?
    self.print_user = operator if self.print_user.nil?
    self.print_date = Date.today if self.print_date.nil?
    self.save

    if bill_item.receipt
      return
    end

    details << bill_item

    bill_item.receipt_no = self.receipt_no
    bill_item.save!

  end

  def add_account_item(account_detail, operator='系统')

    self.house = House.find(account_detail.house_id) if self.house.nil?
    self.plot = Plot.find(account_detail.plot_id) if self.plot.nil?
    self.print_user = operator if self.print_user.nil?
    self.print_date = Date.today if self.print_date.nil?
    self.save

    if account_detail.receipt
      return
    end

    account_details << account_detail

    account_detail.receipt_no = self.receipt_no
    account_detail.save!

  end

  def total_account_money
    account_details.map { |detail| detail.money }.inject { |sum, money| sum + money }
  end

  def total_money
    details.map { |detail| detail.money }.inject { |sum, money| sum + money }
  end

  def total_pay_money
    details.map { |detail| detail.pay_money }.inject { |sum, money| sum + money }
  end

  def total_account_discount_money
    account_details.map { |detail| detail.discount_money }.inject { |sum, money| sum + money }
  end

  def init_info

    self.company_info = Company.find(self.plot.company_id).name

    self.house_info = "#{self.plot.name}\\#{self.house.area.name}\\#{self.house.house_code} #{self.house.owner_names}"
  end
end

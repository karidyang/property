#coding:utf-8
class BillItem < ActiveRecord::Base
  belongs_to :bill

  before_create :default_value_for_create

  def default_value_for_create
    self.status = STATE[:unpay]
    if !self.unit_price.nil? && !self.record.nil?
      self.money = self.unit_price * self.record
    else
      self.money = self.unit_price
    end
  end

  STATE = {
      #未付款
      :unpay => 0,
      #付款
      :pay => 1
  }

  def pay
    self.pay_money = self.money
    self.pay_date = Date.today
    self.status = STATE[:pay]
    self.save!
  end

  def reset
    self.pay_money = 0.0
    self.pay_date = nil
    self.status = STATE[:unpay]
    self.save!
  end

  def self.find_by_date(house_id, charge_id, charge_type, date)
    first_day = date.at_beginning_of_month
    last_day = date.at_end_of_month
    self.where("house_id = ? and item_id = ? and item_type=? and trans_time >= ? and trans_time <= ? ", house_id, charge_id, charge_type, first_day, last_day).first
  end
end
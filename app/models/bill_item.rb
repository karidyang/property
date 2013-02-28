#coding:utf-8
class BillItem < ActiveRecord::Base
  belongs_to :bill
  belongs_to :receipt

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

  def pay(operator='系统')
    if self.status == STATE[:unpay]
      self.pay_money = self.money
      self.pay_date = Date.today
      self.status = STATE[:pay]
      self.operator=operator
      self.save!
    end
  end

  def reset(operator='系统')
    if self.status == STATE[:pay]
      self.pay_money = 0.0
      self.pay_date = nil
      self.status = STATE[:unpay]
      self.push_money = 0.0
      self.operator=operator
      self.save!
    end
  end

  def push_item(can_push=false, operator='系统')

    @push_money = 0
    if can_push
      @push_money = push_money(operator)
    end
    if @push_money.zero?
      self.push = 0
      if self.pay_money == self.money
        self.status = STATE[:pay]
      else
        self.status = STATE[:unpay]
        self.pay_money = 0
      end
    else
      if @push_money>= self.money

        self.status = STATE[:pay]
        self.pay_date = self.trans_time
        self.operator = operator
      else
        self.status = STATE[:unpay]
      end
      self.pay_money = 0
      self.push = @push_money
    end
    self.save!
  end

  def push_money(operator = '系统')
    #Account account = accountDao.findUniqueAccountByHouseAndItem(houseId, itemType.getType(), itemId)
    account = Account.find_account_by_house(self.house_id, self.item_type, self.item_id)
    return 0 if account.nil? || account.money==0
    sum_push_money = 0
    account.in_details.each do |account_item|
      can_push = account_item.can_push
      true_push_money = 0
      trans_time = self.trans_time
      #if account_item.trans_time < trans_time
        return 0 if account.money <= 0
        if account.money >= self.money
          true_push_money += self.money
        else
          true_push_money += account.money
        end
        banlance = (account.money - true_push_money).abs
        if banlance < can_push
          true_push_money = true_push_money - (can_push - banlance)
          banlance = can_push
        end
        if true_push_money>0
          puts "#{account.house_code}冲销[#{account.item_name}],金额: #{true_push_money}"
          account.push(true_push_money, banlance, trans_time, operator)
          sum_push_money += true_push_money
        end
        break
      #end
    end
    sum_push_money
  end

  def self.find_by_date(house_id, charge_id, charge_type, date)
    first_day = date.at_beginning_of_month
    last_day = date.at_end_of_month
    self.where("house_id = ? and item_id = ? and item_type=? and trans_time >= ? and trans_time <= ? ", house_id, charge_id, charge_type, first_day, last_day).first
  end

  def json
    {id:self.id, item_name:self.item_name, money:self.money, pay_money:self.pay_money, push:self.push, record:self.record, unit_price:self.unit_price,start_record:self.start_record,end_record:self.end_record,trans_time:self.trans_time,status:self.status,receipt_no:self.receipt_no}
  end

  class << self
    def search_by_house(plot, params)
      house = House.search(plot, params)
      BillItem.where("house_id=? and status = ? and trans_time between ? and ?", house.id, params[:charge_type], params[:start_time], params[:end_time])
    end
  end
end

#coding: utf-8
class Bill < ActiveRecord::Base
  belongs_to :house
  has_many :bill_items

  before_create :default_value_of_create

  def default_value_of_create
    self.bill_status = STATE[:unpay]
  end


  STATE = {
      #未付款
      :unpay => 0,
      #付款
      :pay => 1
  }
  #账单付款
  def pay(item_ids = [])
    if item_ids.empty?
      return
    end

    bill_items.each do |bi|

      if item_ids.include?(bi.id)
        bi.pay
      end
    end
    check_status
  end

  #账单重置
  def reset(item_ids = [])
    if item_ids.empty?
      return
    end
    bill_items.each do |bi|
      if item_ids.include?(bi.id)
        bi.reset
      end
    end
    check_status
  end

  def check_status
    bill_items.each do |bi|
      bill_status_sum += bi.status
    end
    if bill_status_sum == bill_items.size
      self.bill_status = STATE[:pay]
    end
  end


  def self.current_month_bill(house_id, day=Date.today)
    puts house_id, day
    first_day = day.at_beginning_of_month
    last_day = day.at_end_of_month
    bill = self.where("house_id=? and bill_date between ? and ?", house_id, first_day, last_day).first
    if bill.nil?
      #bill = new Bill(billDate.getTime(), DateUtils.getYear(billDate) + "年" + DateUtils.getMonth(billDate)
      #+ "月账单", 0f);
      house = House.find(house_id)
      bill = Bill.create(
          :bill_date => day,
          :bill_name => "#{day.year}年#{day.month}月账单",
          :curr_money => 0.0,
          :house => house,
          :plot_id => house.plot_id
      )
    end
    bill
  end

  def add_item(bill_item, can_push=false)
    push_money = 0
    if can_push
      push_money = push_money(bill_item)
    end
    if push_money.zero?
      bill_item.push = 0
      if bill_item.pay_money == bill_item.money
        bill_item.status = STATE[:pay]
      else
        bill_item.status = STATE[:unpay]
        bill_item.pay_money = 0
      end
    else
      if push_money>= bill_item.money

        bill_item.status = STATE[:pay]
        bill_item.pay_date = bill_item.trans_time
      else
        bill_item.status = STATE[:unpay]
      end
      bill_item.pay_money = 0
      bill_item.push = push_money
    end

    self.bill_items << bill_item
    self.curr_money = bill_items.map { |detail| detail.money }.inject { |sum, money| sum + money }
    sum_status = bill_items.map { |detail| detail.status }.inject { |sum, status| sum + status }
    puts "bill_item sum_status = #{sum_status}, bill_items.size = #{bill_items.size}"
    self.bill_status = STATE[:pay] if sum_status == bill_items.size
    self.save!
  end

  def push_money(bill_item)
    #Account account = accountDao.findUniqueAccountByHouseAndItem(houseId, itemType.getType(), itemId)
    account = Account.find_account_by_house(bill_item.house_id, bill_item.item_type, bill_item.item_id)
    return 0 if account.nil? || account.money==0
    sum_push_money = 0
    account.in_details.each do |account_item|
      can_push = account_item.can_push
      true_push_money = 0
      trans_time = bill_item.trans_time
      if account_item.trans_time < trans_time
        return 0 if account.money <= 0
        if account.money >= bill_item.money
          true_push_money += bill_item.money
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
          account.push(true_push_money, banlance, trans_time)
          sum_push_money += true_push_money
        end
        break
      end
    end
    sum_push_money
  end
end

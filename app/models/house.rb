# coding: utf-8  
class House < ActiveRecord::Base
  belongs_to :area
  belongs_to :plot
  has_many :owners, :order => "name"
  has_many :accounts, :order => "item_name"
  has_and_belongs_to_many :charges
  has_many :bills, :order => "bill_date"
  has_many :unpay_bills, :class_name => "Bill", :conditions => "bill_status = 0"

  def to_json
    "{'id':'h-#{self.id}','name':'#{self.house_code}'}"
  end

  def add_charge(charge)
    if charges.include?(charge)
      charges << charge
    end
  end

  def owner_names
    owners.map { |owner| owner.name }.flatten.uniq.join(',')
  end

  def last_bill
    bills.first
  end

  #生成账单
  def create_bill(day = Date.today, operator=nil)
    #1、是否有业主、是否业主已收房
    #2、查询本月是否已经生成账单，未生成则新建，否则追加
    #3、循环收费项，根据收费项生成账单详细
    return if can_create_bill?
    begin
      Bill.transaction do

        bill = Bill.current_month_bill(self.id, day)

        charges.each do |charge|
          if charge.period == Charge::PERIOD[:month]
            unit_price = charge.price
            record = 0
            puts "charge.unit_type == #{charge.unit_type}"
            if charge.unit_type == 1
              record = self.builded_area
            else
              record = charge.item_num
            end
            puts "record == #{record}"
            bill_item = BillItem.find_by_date(self.id, charge.id, Charge::TYPE[:custom], day)
            if bill_item.nil?
              bill_item = BillItem.create(
                  :item_name => charge.item_name,
                  :item_id => charge.id,
                  :item_type => Charge::TYPE[:custom],
                  :house_id => self.id,
                  :plot_id => self.plot.id,
                  :unit_price => unit_price,
                  :record => record,
                  :start_record => 0,
                  :end_record => 0,
                  :trans_time => day,
                  :operator => operator
              )
              if bill_item.money > 0
                puts "#{self.house_code}新增费用[#{charge.item_name}]=#{bill_item.money}"
                bill.add_item(bill_item, true)
              end
            end
          end
        end
      end
    rescue => e
      puts "#{self.house_code}统计费用出现错误"
    end

  end

  def can_create_bill?
    result = true
    result = false if owners.empty? || self.receive_time.nil?

    #收房日期大于当月20号
    today = Date.today

    if today.month == self.receive_time.month && self.receive_time.day > 20
      result = false
    elsif today < self.receive_time
      result = false
    end
    result
  end


end

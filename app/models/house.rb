# coding: utf-8
class House < ActiveRecord::Base

  validates_presence_of :builded_area, :message => '建筑面积不能为空'
  validates_presence_of :real_area, :message => '实际面积不能为空'
  validates_presence_of :share_area, :message => '公摊面积不能为空'
  validates_format_of :house_code, :with => /\d*-\d*-\d*-\d*/, :message => '房间号规则不正确，请参考1-1-1-1'
  validates :house_code, :presence => {:message => '房间号不能为空'}


  belongs_to :area
  belongs_to :plot
  has_many :owners, :order => 'name'
  has_many :accounts, :order => 'item_name'
  has_and_belongs_to_many :charges
  has_many :bills, :class_name => 'Bill', :order => 'bill_date desc'
  has_many :unpay_bills, :class_name => 'Bill', :conditions => 'bill_status = 0', :order => 'bill_date desc'
  has_many :pay_bills, :class_name => 'Bill', :conditions => 'bill_status = 1', :order => 'bill_date desc'
  has_many :unpay_bill_items, :class_name => 'BillItem', :foreign_key=> 'house_id', :conditions => 'status = 0', :order => 'trans_time'
  has_many :pay_bill_items, :class_name => 'BillItem', :foreign_key=> 'house_id', :conditions => 'status = 1', :order => 'trans_time'
  self.per_page = 10

  def self.find_house(plot_id, house_code=nil)
    if plot_id.nil? && house_code.nil?
      self.order('house_code')
    elsif house_code.nil?
      self.where('plot_id=?', plot_id).order('house_code')
    else
      self.where('plot_id=? and house_code=?', plot_id, house_code).order('house_code')
    end
  end

  def to_json
    "{\"id\":\"h-#{self.id}\",\"name\":\"#{self.house_code}|#{self.owner_name}\"}"
  end

  def json
    {id: self.id, house_code: self.house_code, owner_name: self.owner_names, builded_area: self.builded_area, use_type: self.get_use_type(self.use_type)}
  end

  def get_use_type(use_type)
    {1 => '住宅', 2 => '商铺', 3 => '商服', 4 => '车库', 5 => '其他'}.each do |key, value|
      if key.to_i==use_type
        return value
      end
    end
  end

  def add_charge(charge)
    if charges.include?(charge)
      charges << charge
    end
  end

  def owner_names
    owners.map { |owner| owner.name }.flatten.uniq.join(',')
  end

  def owner_phone
    owners.map { |owner| owner.phone }.flatten.uniq.join(',')
  end


  def last_bill
    bills.first
  end

  #生成账单
  def create_bill(day = Date.today, operator=nil)
    #1、是否有业主、是否业主已收房
    #2、查询本月是否已经生成账单，未生成则新建，否则追加
    #3、循环收费项，根据收费项生成账单详细
    return if !can_create_bill?
    logger.info "开始计算#{self.house_code}#{day.year}年#{day.month}月账单"
    begin
      Bill.transaction do

        bill = Bill.current_month_bill(self.id, day)

        charges.each do |charge|
          if charge.period == Charge::PERIOD[:month]
            unit_price = charge.price
            record = 0
            if charge.bind_area?
              record = self.builded_area
            else
              record = charge.item_num
            end
            #puts "record == #{record}"
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
      puts e
      puts "#{self.house_code}统计费用出现错误"
    end

  end

  def can_create_bill?
    return false if owners.empty? || self.receive_time.nil?
    result = true

    #收房日期大于当月20号
    today = Date.today

    if today.month == self.receive_time.month && self.receive_time.day > 20
      result = false
    elsif today < self.receive_time
      result = false
    end
    result
  end

  # 获取房间对应的未付款账单集合，集合返回一个hash对象
  def unpay
    unpay = BillItem.unpay_item(id)
    money = pay_money = push = sub_money = 0
    details = []
    unpay.each do |e|
      money += e[:money]
      pay_money += e[:pay_money]
      push += e[:push]
      sub_money += e[:sub_money]
      details << e
    end
    unpays = {}
    unpays[:details] = details
    unpays[:total_money] = money
    unpays[:total_pay_money] = pay_money
    unpays[:total_push] = push
    unpays[:total_sub_money] = sub_money
    unpays[:house_info] = "#{house_code} #{owner_name}"
    unpays[:title] = "#{plot.name}欠费催款单"
    unpays
  end

  class << self
    def search(plot, params)
      self.where('plot_id=? and house_code=?', plot, params[:house_code]).first
    end
  end

  def unpay_wuguan_money
    total_moeny = 0
    # unpay_bills.each do |bill|
      pay_bill_items.each { |b| total_moeny += b.money if b.charge.bind_area }
    # end
    total_moeny
  end

  def unpay_other_money
    total_moeny = 0
    # unpay_bills.each do |bill|
      unpay_bill_items.each { |b| total_moeny += b.money unless b.charge.bind_area }
    # end
    total_moeny
  end

  # 欠费总金额
  def total_unpay_money
    total_moeny = 0
    # unpay_bills.each do |bill|
      pay_bill_items.each { |b| total_moeny += b.money }
    # end
    total_moeny
  end

  def self.import_by_excel(excel, plot_id)
    book = Spreadsheet.open(excel)
    sheet = book.worksheet(0)
    sheet.each 1 do |row|
      puts row
      house_code = row[0].to_s

      builded_area = row[1].to_f
      real_area = row[2].to_f
      share_area = row[3].to_f
      receive_time = row[4].to_date
      checkin_time = row[5].to_date
      owners = row[6].to_s
      owner_phone = row[7].to_s

      #1.查找栋号
      area_name = house_code.split("-")[0]+"栋"
      @area = Area.find_by_name(area_name)
      @area = Area.create(name: area_name, plot_id: plot_id) unless @area


      #2.查找房号
      @house = House.find_by_house_code(house_code)
      next if @house

      @house = House.create(
          house_code: house_code,
          area_id: @area.id,
          plot_id: plot_id,
          builded_area: builded_area,
          real_area: real_area,
          share_area: share_area,
          owner_name: owners,
          receive_time: receive_time,
          checkin_time: checkin_time,
          status: 1,
          use_type: 1,
          unit_id: 1

      )

      #3.查找业主
      @owner = Owner.find_by_house_id_and_name(@house.id, owners)
      next if @owner
      Owner.create(
          name: owners,
          house_id: @house.id,
          phone: owner_phone
      )


    end
  end


  private
  def build_time(unpay, item)
    if unpay[:start_time] && unpay[:end_time]
      if item.trans_time > unpay[:end_time]
        unpay[:end_time] = item.trans_time
      elsif item.trans_time < unpay[:start_time]
        unpay[:start_time] = item.trans_time
      end
    else
      unpay[:start_time] = item.trans_time
      unpay[:end_time] = item.trans_time
    end
  end
end

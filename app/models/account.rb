# -*- encoding : utf-8 -*-
class Account < ActiveRecord::Base
  belongs_to :house
  has_many :account_details, :dependent => :delete_all, :order => 'trans_time desc'
  has_many :in_details, :class_name => 'AccountDetail', :conditions => 'account_type=0'
  has_many :out_details, :class_name => 'AccountDetail', :conditions => 'account_type=1'

  before_create :default_money
  self.per_page = 10
  STATE = {
      :in => 0,
      :out => 1
  }


  def default_money
    self.money = 0
  end

  def transcation_in (detail, operator='系统')
    self.money = self.money + detail.money
    detail.account_type = STATE[:in]
    detail.updateby = operator
    detail.save
    account_details << detail
  end

  def transcation_out (detail, operator='系统')
    self.money = self.money - detail.money
    detail.account_type = STATE[:out]
    detail.updateby = operator
    detail.save
    account_details << detail
  end

  def transcation_to (params, operator='系统')
    dest_account = Account.find_by_item_id_and_house_id(params[:item_id], self.house.id)
    dest_item = Charge.find(params[:item_id])

    if dest_account.nil?
      dest_account = Account.create(
          :house_id => self.house.id,
          :house_code => self.house.house_code,
          :item_id => params[:item_id],
          :item_type => params[:item_type],
          :item_name => dest_item.item_name,
          :plot_id => self.plot_id
      )

    end

    out_detail = AccountDetail.new(
        :account_type => STATE[:out],
        :money => params[:money],
        :record => 1,
        :unit_price => params[:money],
        :updateby => operator,
        :note => params[:note]
    )
    self.transcation_out(out_detail, operator)
    self.save

    in_detail = AccountDetail.new(
        :account_type => STATE[:in],
        :money => params[:money],
        :record => 1,
        :unit_price => params[:money],
        :updateby => operator,
        :note => params[:note]
    )
    dest_account.transcation_in(in_detail, operator)
    dest_account.save
  end

  def can_push
    return 0 if account_details.nil?
    account_details.map { |detail| detail.can_push }.inject { |sum, can_push| sum + can_push }
  end

  def del_detail(detail)
    self.money = self.money - detail.money
    if detail.delete
      self.save
    else
      #删除失败，还原
      self.money = self.money + detail.money
    end
  end

  def self.add_pre_money(params, operator='系统')
    begin
      #@house = House.find(params[:house_id])
      detail = AccountDetail.new
      detail.unit_price = params[:unitPrice]
      detail.record = params[:record]
      detail.can_push = params[:can_push] || 0.00
      detail.money = params[:money]
      detail.updateby = operator
      detail.house_id = params[:house_id]
      detail.plot_id = params[:plot_id]
      detail.discount = params[:discount]
      detail.calculate_discount_money

      account = Account.find_by_item_id_and_house_id(params[:item_id], params[:house_id])
      charge = Charge.find(params[:item_id])

      detail.item_id = params[:item_id]
      detail.item_name = charge.item_name

      if account.nil?
        account = Account.create(:house_id => params[:house_id],
                                 :house_code => params[:house_code],
                                 :item_id => params[:item_id],
                                 :item_type => params[:item_type],
                                 :item_name => charge.item_name,
                                 :plot_id => params[:plot_id])

      end

      account.transcation_in(detail, operator)
      account.save
    rescue Exception => e
      puts e
      nil
    end

  end

  def charges
    Charge.where("plot_id=?", self.plot_id)
  end

  def push(true_push_money, banlance, trans_time, operator = '系统')
    self.money = banlance
    account_item = AccountDetail.create(
        :account_type => STATE[:out],
        :trans_time => trans_time,
        :money => true_push_money,
        :record => 1,
        :unit_price => true_push_money,
        :updateby => operator,
        :note => "用于冲销",
        :can_push => 0,
        :account => self
    )
    account_details << account_item
    out_details << account_item
    self.save!
  end

  def self.find_account_by_house(house_id, item_type, item_id)
    Account.where("house_id=? and item_type=? and item_id=?", house_id, item_type, item_id).order("id desc").first
  end

  def json
    {id: self.id, item_name: self.item_name, money: self.money, can_push: self.can_push, discount_money: self.discount_money}
  end

  def discount_money
    return 0 if account_details.nil?
    account_details.map { |detail| detail.discount_money }.inject { |sum, discount_money| sum + discount_money }
  end
end

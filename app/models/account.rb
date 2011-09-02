#coding:utf-8
class Account < ActiveRecord::Base
  belongs_to :house
  has_many :account_details, :dependent => :delete_all
  has_many :in_details, :class_name => 'AccountDetail', :conditions => 'account_type=0'
  has_many :out_details, :class_name => 'AccountDetail', :conditions => 'account_type=1'

  before_create :default_money

  def default_money
    self.money = 0
  end

  def transaction_in (detail)
    self.money = self.money + detail.money
    detail.save
    account_details << detail
  end

  def transaction_out (detail)
    self.money = self.money - detail.money
    detail.save
    account_details << detail
  end
end

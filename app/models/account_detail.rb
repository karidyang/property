#coding:utf-8
class AccountDetail < ActiveRecord::Base
  belongs_to :account
  belongs_to :receipt
  belongs_to :house
  before_create :default_trans_time

  def default_trans_time
    self.trans_time = current_time_from_proper_timezone
  end

  def item_name
    account.item_name
  end

end
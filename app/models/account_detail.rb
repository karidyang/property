# -*- encoding : utf-8 -*-
class AccountDetail < ActiveRecord::Base
  belongs_to :account
  belongs_to :receipt
  belongs_to :house
  before_create :default_trans_time

  validates_inclusion_of :discount, :in => 0.01..1, :message => "折扣只能是0-1之间"

  def default_trans_time
    self.trans_time = current_time_from_proper_timezone
  end

  # def item_name
  #   account.item_name
  # end

  def calculate_discount_money
    self.discount_money = self.money * self.discount
  end
end

#coding:utf-8
class AccountDetail < ActiveRecord::Base
  belongs_to :account
  before_create :default_trans_time

  def default_trans_time
    self.trans_time = current_time_from_proper_timezone
  end

end
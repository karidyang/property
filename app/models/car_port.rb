#coding:utf-8
class CarPort < ActiveRecord::Base
  attr_accessible :port_charge_id, :port_no, :plot_id

  belongs_to :charge, :foreign_key => :port_charge_id
  has_one :car
end

# -*- encoding : utf-8 -*-
#coding:utf-8
class Car < ActiveRecord::Base
  belongs_to :house
  belongs_to :car_port

  def json
    {id: self.id, car_no: self.car_no, port_no: self.car_port.port_no, port_money: self.car_port.charge.price}
  end
end

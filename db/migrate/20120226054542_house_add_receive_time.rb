# -*- encoding : utf-8 -*-
class HouseAddReceiveTime < ActiveRecord::Migration
  def change
    add_column :houses, :receive_time, :date
  end

end

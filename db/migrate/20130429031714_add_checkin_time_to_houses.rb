# -*- encoding : utf-8 -*-
class AddCheckinTimeToHouses < ActiveRecord::Migration
  def change
    add_column :houses, :checkin_time, :date
  end
end

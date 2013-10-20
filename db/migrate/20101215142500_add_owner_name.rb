# -*- encoding : utf-8 -*-
class AddOwnerName < ActiveRecord::Migration
  def change
    add_column :houses, :owner_name, :string

    House.all.each do |house|
      unit_id = house.house_code.split("-")[1]
      house.unit_id = unit_id
      house.save!
    end
  end


end

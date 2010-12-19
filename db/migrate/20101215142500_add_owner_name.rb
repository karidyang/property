class AddOwnerName < ActiveRecord::Migration
  def self.up
    add_column :houses, :owner_name,:string
    
    House.all.each do |house|
      unit_id = house.house_code.split("-")[1]
      house.unit_id = unit_id
      house.save!
    end
  end

  def self.down
  end
end

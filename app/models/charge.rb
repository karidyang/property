#coding: utf-8
class Charge < ActiveRecord::Base
  belongs_to :plot
  has_and_belongs_to_many :houses

  def add_house(house)
    if (!houses.include?(house))
      houses << house
    end
  end

  def house_ids
    house_id = []
    houses.each do |house|
      house_id << house.id
    end
    house_id.join(',')
  end
end

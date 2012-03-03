#coding: utf-8
class Charge < ActiveRecord::Base
  belongs_to :plot
  has_and_belongs_to_many :houses
  PERIOD = {
      :hour => 0,
      :day => 1,
      :month => 2,
      :quarter => 3,
      :year => 4
  }

  TYPE = {
      :custom => 0,
      :meter => 1
  }

  def add_house(house)
    houses << house
  end

  def house_ids
    house_id = []
    houses.each do |house|
      house_id << house.id
    end
    house_id.join(',')
  end
end

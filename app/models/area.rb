# coding: utf-8  
class Area < ActiveRecord::Base
  belongs_to :plot
  has_many :houses, :order=>'house_code'

  def to_json
    "{\"attr\":{\"id\":\"a-#{self.id}\",\"type\":2,\"rel\":\"area\"},\"data\":\"#{self.name}\",\"state\":\"open\",\"children\":[#{houses_json}]}"
  end

  def houses_json
    if !houses.empty?
      json       = []
      house_unit = {}

      houses.each do |house|
        unit_house = []
        if house_unit.has_key?(house.unit_id)
          unit_house = house_unit[house.unit_id]
        end
        unit_house << house.to_json
        house_unit[house.unit_id] = unit_house
      end
      house_unit.each do |k, v|
        json << "{\"attr\":{\"id\":\"u-#{k}\",\"type\":2,\"rel\":\"unit\"},\"data\":\"#{k}单元\",\"state\":\"open\",\"children\":[#{v.join(",")}]}"
      end
      "[#{json.join(",")}]"
    end
  end
end

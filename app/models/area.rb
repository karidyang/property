# coding: utf-8  
class Area < ActiveRecord::Base
  belongs_to :plot
  has_many :houses, :order=>'house_code'
  
  def to_json
    
    "{'id':'a-#{self.id}','name':'#{self.name}',open:false,childs:#{houses_json}}"
  end

  def houses_json
    json = []
    if !houses.empty?
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

        json << "{'id':'u-#{k}','name':'#{k}单元',open:false,'childs':[#{v.join(",")}]}"
      end
    
    end
    "[#{json.join(",")}]"

  end
end

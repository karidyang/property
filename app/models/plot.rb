# coding: utf-8  
class Plot < ActiveRecord::Base
  has_many :areas, :order=>"name"

  def to_json
    json = "{\"attr\":{\"id\":\"p-#{self.id}\",\"type\":1,\"rel\":\"plot\"},\"data\":\"#{self.name}\""
    area_json = []
    areas.each do |area|
      area_json << area.to_json
    end
    if !area_json.empty?
      json += ",\"state\":\"open\",\"children\":[#{area_json.join(",")}]}"
    else
      json += ",\"state\":\"close\"}"
    end
    json
  end
end

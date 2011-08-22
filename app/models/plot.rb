# coding: utf-8  
class Plot < ActiveRecord::Base
  has_many :areas, :order=>"name"

  def to_json
    #json = "{\"attr\":{\"id\":\"p-#{self.id}\",\"type\":1,\"rel\":\"plot\"},\"data\":\"#{self.name}\""
    json = "{'id':'p-#{self.id}','name':'#{self.name}','open':'true',nocheck:true"
    area_json = []
    areas.each do |area|
      area_json << area.to_json
    end
    if !area_json.empty?
      json += ",'nodes':[#{area_json.join(",")}]}"
    end
    json
  end
end

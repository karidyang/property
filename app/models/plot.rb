# -*- encoding : utf-8 -*-
class Plot < ActiveRecord::Base
  has_many :areas, :order => "name"
  self.per_page = 10

  def to_json
    #json = "{\"attr\":{\"id\":\"p-#{self.id}\",\"type\":1,\"rel\":\"plot\"},\"data\":\"#{self.name}\""
    json = "{\"id\":\"p-#{self.id}\",\"name\":\"#{self.name}\""
    area_json = []
    areas.each do |area|
      area_json << area.to_json
    end
    if area_json.empty?
      json += ",\"open\":true,\"childs\":[]}"
    else
      json += ",\"open\":true,\"childs\":[#{area_json.join(",")}]}"
    end
    json
  end
end

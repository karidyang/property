# coding: utf-8  
class House < ActiveRecord::Base
  belongs_to :area
  belongs_to :plot
  has_many :owners, :order=>"name"

  def to_json
    "{\"attr\":{\"id\":#{self.id},\"type\":3,\"rel\":\"house\"},\"data\":\"#{self.house_code}\",\"state\":\"\"}"
  end
end

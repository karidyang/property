# coding: utf-8  
class House < ActiveRecord::Base
  belongs_to :area
  belongs_to :plot
  has_many :owners, :order=>"name"
  has_and_belongs_to_many :charges 

  def to_json
    "{\"attr\":{\"id\":\"h-#{self.id}\",\"type\":3,\"rel\":\"house\"},\"data\":\"#{self.house_code}\",\"state\":\"\"}"
  end
 
  def add_charge(charge)
    if (charges.include?(charge))
      charges << charge
    end
  end
end

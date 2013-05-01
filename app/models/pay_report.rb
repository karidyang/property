class PayReport < ActiveRecord::Base
  self.per_page = 10
  belongs_to :plot
    
  #attr_accessible :item_name, :money, :plot_id, :trans_time, :itme_id
end

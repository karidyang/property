# coding: utf-8  
class Owner < ActiveRecord::Base
  belongs_to :house
  self.per_page = 10


  def sex?
    :sex == 0 ? '女' : '男'
  end
end

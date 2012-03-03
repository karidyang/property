# coding: utf-8  
class Owner < ActiveRecord::Base
  belongs_to :house
    cattr_reader :per_page
    @@per_page = 10

    def sex?
        :sex == 0 ? '女':'男'
    end
end

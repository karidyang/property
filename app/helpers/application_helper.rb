#coding: utf-8
module ApplicationHelper
  def all_plots
    Plot.all.map { |p| [p.name, p.id] }
  end

  def get(hash, set_value)
    hash.each do |key, value|
      if key.to_i == set_value
        return value
      end
    end
  end

  def get_boolean(hash, set_value)
    hash.each do |key, value|
      if (key == set_value)
        return value
      end
    end
  end

  def link_to_add_pre_money(house)
    link_to('新增预存款', :controller => :accounts, :action => :add_pre_money, :house_id => house.id)
  end

  def link_to_add_owner(house)
    link_to('添加业主', :controller=>:owners, :action=>:new, :house_id=>house)
  end
end

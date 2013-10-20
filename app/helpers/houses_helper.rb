# -*- encoding : utf-8 -*-
module HousesHelper


  def all_status
    [['已住', 1], ['未住', 2], ['出租', 3]]
  end

  def all_use_type
    [['住宅', 1], ['商铺', 2], ['商服', 3], ['车库', 4], ['其他', 5]]
  end

  def get_status(status)
    {1 => '已住', 2 => '未住', 3 => '出租'}.each do |key, value|
      if key.to_i==status
        return value
      end
    end
  end

  def get_use_type(use_type)
    {1 => '住宅', 2 => '商铺', 3 => '商服', 4 => '车库', 5 => '其他'}.each do |key, value|
      if key.to_i==use_type
        return value
      end
    end
  end


end

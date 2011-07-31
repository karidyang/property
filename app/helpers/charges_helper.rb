# coding: utf-8  
module ChargesHelper
  def all_period_type
    [['周期',0],['临时',1],['按次',2],['区间',3]]
  end

  def all_period
    [['按小时',0],['按天',1],['按月',2],['按季度',3],['按年',4]]
  end

  def all_unit_type
    [['个数',0],['面积',1],['居住人数',2]]
  end

  def all_return_back
    [['否',0],['是',1]]
  end

  def get_period_type(period_type)
    get({0=>'周期',1=>'临时',2=>'按次',3=>'区间'}, period_type)
    end

  def get_period(period)
    get({0=>'按小时',1=>'按天',2=>'按月',3=>'按季度', 4=>'按年'}, period)
  end

  def get_unit_type(unit_type)
    get({0=>'个数',1=>'面积',2=>'居住人数'}, unit_type)
  end

  def get_return_back(return_back)
    get({0=>'否',1=>'是'}, return_back)
  end



end

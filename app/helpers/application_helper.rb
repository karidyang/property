#coding: utf-8
module ApplicationHelper
  def all_plots
    @current_user.plots.map { |p| [p.name, p.id] }
  end

  def current_plot
    session[:current_plot_name] ||= '未选择小区'
  end

  def charge_type_list
    [['已缴费', 1], ['未缴费', 0]]
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
    link_to('添加业主', :controller => :owners, :action => :new, :house_id => house)
  end

  def all_areas
    Area.where('plot_id=?', session[:current_plot]).map { |a| [a.name, a.id] }
  end

  def backto_plot
    if session[:current_plot]
      root_path
    else
      choose_plot_path
    end
  end

  def all_charges
    Charge.where('plot_id=?', session[:current_plot]).map { |c| ["#{c.item_name}(费用:#{c.price}元)", c.id] }
  end

  def empty_car_ports
    carports = []
    CarPort.where('plot_id=?', session[:current_plot]).each { |p| carports<< p if p.car.nil? }

    carports.map { |p| ["#{p.port_no}(费用:#{p.charge.price}元)", p.id] }
  end

end

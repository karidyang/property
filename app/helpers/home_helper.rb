# -*- encoding : utf-8 -*-
module HomeHelper

  def plot_charges
    charges = []
    charges << ['全部', 0]
    Charge.where('plot_id=?', session[:current_plot]).each { |c| charges << [c.desplay_name, c.id] }
    charges
  end
end

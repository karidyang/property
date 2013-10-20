# -*- encoding : utf-8 -*-
class AddPlotsUsers < ActiveRecord::Migration
  def change
    create_table :plots_users, :id => false do |t|
      t.integer :plot_id, :null => false
      t.integer :user_id, :null => false
    end
  end

  u = User.first
  unless u.nil?
    u.plots << Plot.find(1)
    u.save
  end
end

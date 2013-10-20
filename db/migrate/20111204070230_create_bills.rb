# -*- encoding : utf-8 -*-
class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :bill_name
      t.date :bill_date
      t.integer :bill_status
      t.decimal :curr_money, :precision => 8, :scale => 2
      t.integer :house_id
      t.integer :plot_id

      t.timestamps
    end
  end
end

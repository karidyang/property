# -*- encoding : utf-8 -*-
class CreateBillItems < ActiveRecord::Migration
  def change
    create_table :bill_items do |t|
      t.integer :bill_id
      t.integer :item_id
      t.string :item_name
      t.decimal :money, :precision => 8, :scale => 2
      t.date :trans_time
      t.integer :status
      t.decimal :pay_money, :precision => 8, :scale => 2
      t.date :pay_date
      t.integer :house_id
      t.decimal :unit_price, :precision => 8, :scale => 2
      t.integer :record
      t.integer :start_record
      t.integer :end_record
      t.decimal :push, :precision => 8, :scale => 2
      t.string :operator

      t.timestamps
    end
  end
end

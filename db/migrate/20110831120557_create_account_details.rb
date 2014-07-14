# -*- encoding : utf-8 -*-
class CreateAccountDetails < ActiveRecord::Migration
  def change
    create_table :account_details do |t|
      t.integer :account_id
      t.integer :account_type
      t.decimal :money, :precision => 8, :scale => 2
      t.date :trans_time
      t.string :note
      t.string :updateby
      t.integer :record
      t.decimal :unit_price, :precision => 8, :scale => 2
      t.decimal :can_push, :precision => 8, :scale => 2, :default => 0.00
      t.integer :receipt_id
      t.integer :item_id
      t.string :item_name
      t.string :receipt_no
      t.integer :house_id
      t.integer :plot_id
      t.decimal :discount, :precision => 8, :scale => 2, :default => 1.00
      t.decimal :discount_money, :precision => 8, :scale => 2, :default => 1.00

      t.timestamps
    end

    add_index :account_details, :account_id
  end

end

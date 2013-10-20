# -*- encoding : utf-8 -*-
class AddDiscountToAccountDetails < ActiveRecord::Migration
  def change
    add_column :account_details, :discount, :decimal, :precision => 8, :scale => 2, :default => 1
    add_column :account_details, :discount_money, :decimal, :precision => 8, :scale => 2, :default => 0
  end
end

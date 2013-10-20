# -*- encoding : utf-8 -*-
class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.string :item_name
      t.integer :period_type
      t.decimal :price, :precision => 8, :scale => 2
      t.integer :unit_type
      t.integer :item_num
      t.integer :period
      t.integer :fee_rate, :default => 0
      t.integer :return_back
      t.string :note
      t.integer :plot_id, :null => false

      t.timestamps
    end
    add_index :charges, :plot_id
  end

end

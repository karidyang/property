# -*- encoding : utf-8 -*-
class CreateHouses < ActiveRecord::Migration
  def change
    create_table :houses do |t|
      t.string :house_code
      t.integer :area_id, :null => false
      t.decimal :builded_area, :precision => 8, :scale => 2
      t.decimal :real_area, :precision => 8, :scale => 2
      t.decimal :share_area, :precision => 8, :scale => 2
      t.integer :status
      t.integer :use_type
      t.integer :unit_id
      t.integer :plot_id, :null => false

      t.timestamps
    end
    add_index :houses, :area_id
    add_index :houses, :plot_id
  end


end

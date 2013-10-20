# -*- encoding : utf-8 -*-
class CreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.string :name
      t.integer :age
      t.boolean :sex, :default => 0
      t.string :phone
      t.string :id_card
      t.string :contract_no
      t.integer :house_id, :null => false

      t.timestamps
    end
    add_index :owners, :house_id
  end


end

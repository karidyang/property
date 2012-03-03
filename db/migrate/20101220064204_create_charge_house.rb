class CreateChargeHouse < ActiveRecord::Migration
  def change
    create_table :charges_houses, :id=>false do |t|
      t.integer :charge_id,:null=>false
      t.integer :house_id, :null=>false
    end
  end


end

class CreateChargeHouse < ActiveRecord::Migration
  def self.up
    create_table :charges_houses, :id=>false do |t|
      t.integer :charge_id,:null=>false
      t.integer :house_id, :null=>false
    end
  end

  def self.down
    drop_table :charges_houses
  end
end

class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.string :car_no
      t.integer :house_id
      t.integer :car_port_id

      t.timestamps
    end
  end
end

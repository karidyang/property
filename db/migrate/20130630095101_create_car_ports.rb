class CreateCarPorts < ActiveRecord::Migration
  def change
    create_table :car_ports do |t|
      t.string :port_no
      t.integer :port_charge_id
      t.integer :plot_id, :null => false
      t.timestamps
    end
  end
end

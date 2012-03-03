class HouseAddReceiveTime < ActiveRecord::Migration
  def up
    add_column :houses, :receive_time,:date
  end

  def down
    remove_column :houses, :receive_time
  end
end

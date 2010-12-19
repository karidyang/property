class CreateHouses < ActiveRecord::Migration
  def self.up
    create_table :houses do |t|
      t.string :house_code
      t.integer :area_id, :null=>false
      t.decimal :builded_area
      t.decimal :real_area
      t.decimal :share_area
      t.integer :status
      t.integer :use_type
      t.integer :unit_id
      t.integer :plot_id, :null=>false

      t.timestamps
    end
    add_index :houses, :area_id
    add_index :houses, :plot_id
  end

  def self.down
    drop_table :houses
  end
end

class CreateAreas < ActiveRecord::Migration
  def self.up
    create_table :areas do |t|
      t.string :name
      t.integer :house_num
      t.integer :plot_id
    end
  end

  def self.down
    drop_table :areas
  end
end

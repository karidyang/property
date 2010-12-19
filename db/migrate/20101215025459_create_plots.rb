class CreatePlots < ActiveRecord::Migration
  def self.up
    create_table :plots do |t|
      t.string :name
      t.string :developer
      t.string :constructor
      t.string :address
      t.string :phone
      t.integer :company_id
    end
  end

  def self.down
    drop_table :plots
  end
end

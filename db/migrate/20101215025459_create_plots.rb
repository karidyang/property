class CreatePlots < ActiveRecord::Migration
  def change
    create_table :plots do |t|
      t.string :name
      t.string :developer
      t.string :constructor
      t.string :address
      t.string :phone
      t.integer :company_id
    end
  end


end

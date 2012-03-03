class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
      t.integer :house_num
      t.integer :plot_id
    end
  end


end

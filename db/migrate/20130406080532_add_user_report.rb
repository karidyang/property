class AddUserReport < ActiveRecord::Migration
  def change
    create_table :user_reports do |t|
      t.date :trans_time
      t.integer :item_id
      t.string :item_name
      t.integer :house_id
      t.string :house_code
      t.string :owner
      t.decimal :pay_money, :precision => 8, :scale => 2, :default => 0
      t.decimal :unpay_money, :precision => 8, :scale => 2, :default => 0
      t.decimal :pre_money, :precision => 8, :scale => 2, :default => 0
      t.string :operator
    end
    
  end
end

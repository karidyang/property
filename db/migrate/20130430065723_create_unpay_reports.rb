class CreateUnpayReports < ActiveRecord::Migration
  def change
    create_table :unpay_reports do |t|
      t.integer :plot_id
      t.integer :item_id
      t.string :item_name
      t.decimal :money, precision: 8, scale:2
      t.date :trans_time
    end

    
  end
end

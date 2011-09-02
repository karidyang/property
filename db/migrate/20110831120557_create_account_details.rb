class CreateAccountDetails < ActiveRecord::Migration
  def self.up
    create_table :account_details do |t|
      t.integer :account_id
      t.integer :account_type
      t.decimal :money, :precision=>8, :scale=>2
      t.date :trans_time
      t.string :note
      t.string :updateby
      t.integer :record
      t.decimal :unit_price, :precision => 8, :scale => 2
      t.decimal :can_push, :precision => 8, :scale => 2, :default=>0.00
      t.integer :receipt_id

      t.timestamps
    end
  end

  def self.down
    drop_table :account_details
  end
end

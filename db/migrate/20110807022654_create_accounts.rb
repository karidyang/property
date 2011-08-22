class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :house_id
      t.string :house_code
      t.decimal :money, :precision=>8, :scale=>2
      t.integer :item_id
      t.integer :item_type
      t.string :item_name
      t.integer :plot_id

      t.timestamps
    end

    create_table :accountDetails do |t|
      t.integer :account_id
      t.integer :account_type
      t.decimal :money, :precision=>8, :scale=>2
      t.timestamp :trans_time
      t.integer :record
      t.decimal :unit_price, :precision=>8, :scale=>2
      t.decimal :can_push, :precision=>8, :scale=>2
      t.string :note
      t.string :updateby
      t.integer :receipt_id

      t.timestamps
    end

    add_index :accountDetails, :account_id
  end

  def self.down
    drop_table :accountDetails
    drop_table :accounts
  end
end

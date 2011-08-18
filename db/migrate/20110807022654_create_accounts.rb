class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :house_id
      t.string :house_code
      t.decimal :money,:precision=>8, :scale=>2
      t.integer :item_id
      t.integer :item_type
      t.string :item_name
      t.integer :plot_id

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end

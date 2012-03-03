class CreateAccounts < ActiveRecord::Migration
  def change
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

    add_index :accountDetails, :account_id
  end


end

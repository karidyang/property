class AddReceiptNoToAccountDetail < ActiveRecord::Migration
  def change
    add_column :account_details, :receipt_no, :string
    add_column :account_details, :item_id, :integer
    add_column :account_details, :item_name, :string
  end
end

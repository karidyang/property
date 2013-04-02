class AddReceiptNoToAccountDetail < ActiveRecord::Migration
  def change
    add_column :account_details, :receipt_no, :string

  end
end

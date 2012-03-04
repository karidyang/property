class BillItemAddItemType < ActiveRecord::Migration
  def change
    add_column :bill_items, :item_type, :integer
    add_column :bill_items, :plot_id, :integer
  end
end

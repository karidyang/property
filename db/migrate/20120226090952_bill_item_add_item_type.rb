class BillItemAddItemType < ActiveRecord::Migration
  def up
    add_column :bill_items, :item_type, :integer
    add_column :bill_items, :plot_id, :integer
  end

  def down
    remove_column :bill_items, :item_type
    remove_column :bill_items, :plot_id
  end
end

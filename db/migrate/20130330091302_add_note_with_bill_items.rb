# -*- encoding : utf-8 -*-
class AddNoteWithBillItems < ActiveRecord::Migration
  def change
    add_column :bill_items, :note, :string

  end
end

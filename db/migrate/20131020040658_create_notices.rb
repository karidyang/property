# -*- encoding : utf-8 -*-
class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string :topic
      t.string :content
      t.integer :publish_type
      t.date :expire_date
      t.timestamps
    end
  end
end

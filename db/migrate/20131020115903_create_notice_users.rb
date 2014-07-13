# -*- encoding : utf-8 -*-
class CreateNoticeUsers < ActiveRecord::Migration
  def change
    create_table :notices_users do |t|
      t.integer :notice_id, :null => false
      t.integer :user_id, :null => false
      t.boolean :is_read, :default => false

    end

    add_index :notices_users, [:notice_id, :user_id], unique: true
  end
end

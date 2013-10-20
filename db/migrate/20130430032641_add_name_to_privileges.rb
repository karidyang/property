# -*- encoding : utf-8 -*-
class AddNameToPrivileges < ActiveRecord::Migration
  def change
    add_column :privileges, :name, :string
  end
end

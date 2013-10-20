# -*- encoding : utf-8 -*-
class AddPrivilegeRole < ActiveRecord::Migration
  def change
    create_table :privileges_roles, :id => false do |t|
      t.integer :role_id, :null => false
      t.integer :privilege_id, :null => false
    end

    privileges = Privilege.find(1, 2, 3)
    role = Role.find(1)
    role.privileges << privileges
    role.save
  end


end

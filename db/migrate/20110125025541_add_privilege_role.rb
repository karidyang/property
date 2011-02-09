class AddPrivilegeRole < ActiveRecord::Migration
  def self.up
    create_table :privileges_roles,:id=>false do |t|
      t.integer :role_id,:null=>false
      t.integer :privilege_id,:null=>false
    end
  end

  def self.down
    drop_table :privileges_roles
  end
end

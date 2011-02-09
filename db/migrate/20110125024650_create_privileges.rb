class CreatePrivileges < ActiveRecord::Migration
  def self.up
    create_table :privileges do |t|
      t.string :model_name
      t.string :privilege
    end
  end

  def self.down
    drop_table :privileges
  end
end

#coding:utf-8
class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name

      t.timestamps
    end

    role = Role.create(:name=>'管理员')
    role.save
  end

  def self.down
    drop_table :roles
  end
end

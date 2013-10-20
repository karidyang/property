# -*- encoding : utf-8 -*-
#coding:utf-8
class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name

      t.timestamps
    end

    role = Role.create(:name => '管理员')
    role.save
  end


end

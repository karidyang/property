# -*- encoding : utf-8 -*-
class CreatePrivileges < ActiveRecord::Migration
  def change
    create_table :privileges do |t|
      t.string :model_name
      t.string :privilege
    end

    privilege1 = Privilege.create(:model_name => 'plots', :privilege => 'select,update,index,delete')
    privilege1.save
    privilege2 = Privilege.create(:model_name => 'areas', :privilege => 'select,update,index,delete')
    privilege2.save
    privilege3 = Privilege.create(:model_name => 'houses', :privilege => 'select,update,index,delete,house_tree')
    privilege3.save

  end


end

class CreatePrivileges < ActiveRecord::Migration
  def self.up
    create_table :privileges do |t|
      t.string :model_name
      t.string :privilege
    end

    privilege1 = Privilege.create(:model_name=>'plot',:privilege=>'select,update')
    privilege1.save
    privilege2 = Privilege.create(:model_name=>'area',:privilege=>'select,update')
    privilege2.save
    privilege3 = Privilege.create(:model_name=>'house',:privilege=>'select')
    privilege3.save

  end

  def self.down
    drop_table :privileges
  end
end
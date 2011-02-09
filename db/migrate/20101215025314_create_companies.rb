class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.string :telphone
      t.string :email
    end
  end

  def self.down
    drop_table :companies
  end
end

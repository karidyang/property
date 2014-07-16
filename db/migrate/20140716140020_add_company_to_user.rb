class AddCompanyToUser < ActiveRecord::Migration
  def change
    add_column :users, :company_id, :integer

    add_index :users, :name
    add_index :users, :company_id
  end
end

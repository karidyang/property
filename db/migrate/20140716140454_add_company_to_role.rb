class AddCompanyToRole < ActiveRecord::Migration
  def change
    add_column :roles, :company_id, :integer

    add_index :roles, :company_id
  end
end

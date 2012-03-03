class AddRoleUser < ActiveRecord::Migration
  def change
    create_table :roles_users,:id=>false do |t|
      t.integer :user_id,:null=>false
      t.integer :role_id,:null=>false
    end
  end


end

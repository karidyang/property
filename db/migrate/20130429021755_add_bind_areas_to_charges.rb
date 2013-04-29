class AddBindAreasToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :bind_area, :boolean, :default => false
  end
end

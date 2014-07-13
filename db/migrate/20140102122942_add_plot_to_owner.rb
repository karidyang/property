class AddPlotToOwner < ActiveRecord::Migration
  def change
    add_column :owners, :plot_id, :integer
  end
end

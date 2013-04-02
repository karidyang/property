class AddPlotToAccountDetail < ActiveRecord::Migration
  def change
    add_column :account_details, :plot_id, :integer

    Account.all.each do |account|
      account.account_details.each do |detail|
        detail.plot_id = account.plot_id
        detail.save!

      end
    end
  end
end

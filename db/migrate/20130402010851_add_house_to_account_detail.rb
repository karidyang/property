class AddHouseToAccountDetail < ActiveRecord::Migration
  def change
    add_column :account_details, :house_id, :integer

    Account.all.each do |account|
      account.account_details.each do |detail|
        detail.house_id = account.house.id
        detail.save!
      end
    end
  end
end

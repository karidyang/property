class AddUserReport < ActiveRecord::Migration
  def change
    create_table :user_reports do |t|
      t.date :trans_time
      t.integer :item_id
      t.string :item_name
      t.integer :house_id
      t.string :house_code
      t.string :owner
      t.decimal :pay_money, :precision => 8, :scale => 2, :default => 0
      t.decimal :unpay_money, :precision => 8, :scale => 2, :default => 0
      t.decimal :pre_money, :precision => 8, :scale => 2, :default => 0
      t.string :operator
    end
    puts '----------------bill_item------------------'
    BillItem.all.each do |bill_item|
      userReport = UserReport.new
      userReport.item_id=bill_item.item_id
      userReport.house_id=bill_item.house_id
      userReport.item_name = bill_item.item_name
      userReport.house_code = bill_item.house.house_code
      userReport.owner = bill_item.house.owner_names
      if bill_item.status==1
        userReport.pay_money=bill_item.money
        userReport.trans_time=bill_item.pay_date
      else
        userReport.unpay_money=bill_item.money
        userReport.trans_time=bill_item.trans_time
      end
      userReport.operator=bill_item.operator
      userReport.save!
    end
    puts '-----------------account_detail---------------'
    AccountDetail.all.each do |account_detail|
      userReport = UserReport.new
      puts account_detail.trans_time
      userReport.item_id=account_detail.account.item_id
      userReport.item_name = account_detail.item_name
      userReport.house_id=account_detail.house_id
      userReport.house_code = account_detail.house.house_code
      userReport.owner = account_detail.house.owner_names
      userReport.trans_time=account_detail.trans_time
      userReport.operator=account_detail.updateby
      if account_detail.account_type==0
        userReport.pre_money=account_detail.money
        userReport.save!
      end
    end
  end
end

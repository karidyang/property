namespace :stat do
  desc "stat user report everyday."
  task :user_report => :environment do
    puts "this is user report."
    UserReport.delete_all
    puts '----------------bill_item------------------'
    BillItem.where('pay_date=?',Date.today.to_s).each do |bill_item|
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
    AccountDetail.where('trans_time=?',Date.today.to_s).each do |account_detail|
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

  desc "stat pay report everyday."
  task :pay_report => :environment do
    puts 'this is pay report'
    result = ActiveRecord::Base.connection.execute("select plot_id, t.`pay_date`,item_id,item_name,sum(money)
from bill_items t
where t.status=1
and pay_date=date_add(curdate(),interval -1 day)
group by plot_id,trans_time, item_id,item_name
order by pay_date")
    PayReport.delete_all
    result.map do |r|
      PayReport.create!(
          plot_id: r[0],
          trans_time: r[1].to_date,
          item_id: r[2],
          item_name: r[3],
          money: r[4]
      )

    end
  end

  desc "stat unpay report everyday."
  task :unpay_report => :environment do
    puts "this is unpay report."
    UnpayReport.delete_all
    result = ActiveRecord::Base.connection.execute("select plot_id, t.trans_time,item_id,item_name,sum(money)
from bill_items t
where t.status=0
and trans_time=date_add(curdate(),interval -1 day)
group by plot_id,trans_time, item_id,item_name
order by pay_date")

    result.map do |r|
      UnpayReport.create!(
          plot_id: r[0],
          trans_time: r[1].to_date,
          item_id: r[2].to_i,
          item_name: r[3],
          money: r[4]
      )

    end
  end
end
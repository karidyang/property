class CreatePayReports < ActiveRecord::Migration
  def change
    create_table :pay_reports do |t|
      t.integer :plot_id
      t.integer :item_id
      t.string :item_name
      t.decimal :money, precision: 8, scale:2
      t.date :trans_time
    end

#     result = ActiveRecord::Base.connection.execute("select plot_id, t.`pay_date`,item_id,item_name,sum(money)
# from bill_items t
# where t.status=1
# group by plot_id,trans_time, item_id,item_name
# order by pay_date")

#     result.map do |r|
#       PayReport.create!(
#           plot_id: r[0],
#           trans_time: r[1].to_date,
#           item_id: r[2],
#           item_name: r[3],
#           money: r[4]
#       )

#     end
  end
end

class UserReport < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :charge
  belongs_to :house

  def self.find_by_user(start_time = nil, end_time = nil)
    sql = "select concat(min(trans_time),'~~~',max(trans_time)) trans_time,
            operator,
            sum(total_pay_money) total_pay_money,
            sum(total_pre_money) total_pre_money
          from (
          select r.trans_time, item_id,operator,sum(pay_money) total_pay_money ,sum(pre_money) total_pre_money
          from user_reports r where (pay_money>0 or pre_money>0) "
    #params = {}
    #if !start_time.nil?
    #  sql += " and t.trans_time >= :start_time"
    #  params[:start_time] = start_time
    #end
    #if !end_time.nil?
    #  sql += " and t.trans_time <= :end_time"
    #  params[:end_time] = end_time
    #end
    sql += "group by r.trans_time,operator
          ) a
          group by operator
          order by trans_time "


    result = ActiveRecord::Base.connection.execute(sql)
    result.map { |r| {trans_time: r[0], operator: r[1], total_pay_money: r[2]+r[3]} }
  end

  def self.find_by_user_detail(user)
    sql = "select concat(min(trans_time),'~~~',max(trans_time)) trans_time,
            (select item_name from charges where id=item_id) item_name,
            item_id,
            operator,
            sum(total_pay_money) total_pay_money,
            sum(total_pre_money) total_pre_money
          from (
          select r.trans_time, item_id,operator,sum(pay_money) total_pay_money ,sum(pre_money) total_pre_money
          from user_reports r where (pay_money>0 or pre_money>0)
          and r.operator='#{user}'
          group by r.trans_time,item_id,operator
          ) a
          group by item_id, operator
          order by trans_time "
    result = ActiveRecord::Base.connection.execute(sql)
    result.map { |r| {trans_time: r[0], item_name: r[1], item_id:r[2], operator: r[3], total_pay_money: r[4]+r[5] }}

  end
end

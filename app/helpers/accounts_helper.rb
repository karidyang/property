#coding:utf-8
module AccountsHelper
  def account_history(account)
    link_to('历史记录', :controller => "accounts", :action => "history", :id => account.id)
  end

  def del_detail(detail_id)
    link_to '删除', {:controller=>:accounts, :action=>:delete_detail, :detail_id=>detail_id}, :confirm => '确定删除？', :method => :delete
  end

  def get_account_type(type)
    {0=>'存入', 1=>'支出'}.each do |key, value|
      if key.to_i==type
        return value
      end
    end
  end
end

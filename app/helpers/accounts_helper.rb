#coding:utf-8
module AccountsHelper
  def link_to_history(account)
    link_to('历史记录', :controller => "accounts", :action => "history", :id => account.id)
  end
end

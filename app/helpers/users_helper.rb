# -*- encoding : utf-8 -*-
#coding:utf-8
module UsersHelper
  def user_name_tag(user)
    result = '来访者'
    if user
      result = "<a href=\"#{user_path(user.id)}\" title=\"#{user.name}\">#{user.name}</a>"
    end
    raw(result)
  end
end

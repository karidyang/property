# -*- encoding : utf-8 -*-
#coding:utf-8
module RolesHelper

  def get_privileges_list
    @privileges = Privilege.all
  end
end

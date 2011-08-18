#coding:utf-8
module OwnersHelper

  def get_sex(sex)
    get_boolean({false=>'女',true=>'男'}, sex)
  end
end

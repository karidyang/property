#coding:utf-8
class Receipt < ActiveRecord::Base
  has_many :details
end

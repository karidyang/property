# coding: utf-8  
class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  cattr_reader :per_page
  @@per_page = 10
end

#coding: utf-8
class Charge < ActiveRecord::Base
  belongs_to :plot
  has_and_belongs_to_many :houses
end

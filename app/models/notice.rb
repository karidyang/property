# -*- encoding : utf-8 -*-
class Notice < ActiveRecord::Base
  attr_accessible :content, :topic, :publish_type, :expire_date

  validates_presence_of :topic, :content, :publish_type, :message => '未填写'
  validates_inclusion_of :publish_type, :in => 1..2

end

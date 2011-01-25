# coding: utf-8  
class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :privileges
  cattr_reader :per_page
  @@per_page = 10

  def has_privilege?(model_name, operator_name, option={})
    privileges.each do |pri|
      return true if pri.has_privilege?(model_name, operator_name, option)
    end
  end

end

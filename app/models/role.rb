# -*- encoding : utf-8 -*-
class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :privileges
  validates :name, :presence => true
  self.per_page = 10

  def has_privilege?(model_name, operator_name, option={})
    privileges.each do |pri|
      return true if pri.has_privilege?(model_name, operator_name, option)
    end
    false
  end

end

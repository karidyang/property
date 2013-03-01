# coding: utf-8  
class User < ActiveRecord::Base
  attr_protected :state
  acts_as_authentic
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :plots

  validates_presence_of :name, :email
  validates_uniqueness_of :email
  before_create :default_value_for_create
  self.per_page = 10
  def default_value_for_create
    self.state = STATE[:normal]
  end
  STATE = {
    :normal => 1,
    # 屏蔽
    :blocked => 2
  }

  def self.cached_count
    return Rails.cache.fetch("users/count",:expires_in => 1.hours) do
      self.count
    end
  end

  def role_names
    roles.map {|role| role.name}.flatten.uniq
    #role_name = []
    #roles.each { |role| role_name << role.name }
    #role_name
  end

  def has_privilege?(model_name, operator_name, option={})
    roles.each do |role|
      return true if role.has_privilege?(model_name, operator_name, option)
    end
    false
  end
end

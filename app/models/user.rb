# coding: utf-8  
class User < ActiveRecord::Base
  has_and_belongs_to_many :roles

  def role_names
    role_name = []
    roles.each { |role| role_name << role.name }
    role_name
  end
end

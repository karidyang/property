# coding: utf-8  
class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  cattr_reader :per_page
  @@per_page = 10

  def role_names
    role_name = []
    roles.each { |role| role_name << role.name }
    role_name
  end
end

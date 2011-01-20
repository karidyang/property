# coding: utf-8  
class User < ActiveRecord::Base
  acts_as_authentic
  has_and_belongs_to_many :roles

  validates_presence_of :name, :email
  validates_presence_of :passwd, :on => :create

  def role_names
    role_name = []
    roles.each { |role| role_name << role.name }
    role_name
  end
end

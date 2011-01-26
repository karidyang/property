class Privilege < ActiveRecord::Base
  has_and_belongs_to_many :roles

  def has_privilege?(model_name, operator_name, option={})
    true if self.model_name.eql?(model_name) && self.privilege.include?(operator_name)
  end
end

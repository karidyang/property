#coding: utf-8
require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  fixtures :roles, :privileges
  # Replace this with your real tests.
  test "role add privilege" do
    role = roles(:system)
    privilege_1 = privileges(:plot)
    privilege_2 = privileges(:area)
    role.privileges << privilege_1
    role.privileges << privilege_2

    assert_equal 2 , role.privileges.size

    assert role.has_privilege?('plot','select')
    assert role.has_privilege?('area','select')
    assert !role.has_privilege?('area','update')
  end
end

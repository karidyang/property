#coding: utf-8
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users,:roles
  # Replace this with your real tests.
  test "test add role to user" do
    user = users(:one)
    assert_not_nil (user)
    role = roles(:system)
    user.roles << role
    assert_equal ['管理员'], user.role_names
  end

end

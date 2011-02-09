#coding: utf-8
require 'test_helper'

class PrivilegeTest < ActiveSupport::TestCase
  fixtures :privileges
  # Replace this with your real tests.
  test "test has privilege" do
    privilege = privileges(:plot)
    assert privilege.has_privilege?('plot','select')
    assert !privilege.has_privilege?('plot','delete')
  end
end
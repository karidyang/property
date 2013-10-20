# -*- encoding : utf-8 -*-
require 'spec_helper'

describe BillItem do
  it "can be instanced" do
    BillItem.new.should be_an_instance_of(BillItem)
  end
end

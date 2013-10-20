# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Bill do

  it "can be instantiated" do

    Bill.new.should be_an_instance_of(Bill)

  end

  it "can be saved successfully" do

    Bill.create.should be_persisted

  end

  it "can be saved" do

    Bill.new.should be_new_record
  end

end

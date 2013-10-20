# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ReceiptController do

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'print'" do
    it "returns http success" do
      get 'print'
      response.should be_success
    end
  end

end

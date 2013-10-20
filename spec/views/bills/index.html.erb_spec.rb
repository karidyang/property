# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "bills/index.html.erb" do
  before(:each) do
    assign(:bills, [
        stub_model(Bill,
                   :bill_name => "Bill Name",
                   :bill_status => 1,
                   :curr_money => "9.99",
                   :house_id => 1,
                   :plot_id => 1
        ),
        stub_model(Bill,
                   :bill_name => "Bill Name",
                   :bill_status => 1,
                   :curr_money => "9.99",
                   :house_id => 1,
                   :plot_id => 1
        )
    ])
  end

  it "renders a list of bills" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Bill Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end

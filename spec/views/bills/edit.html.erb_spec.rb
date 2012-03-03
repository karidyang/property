require 'spec_helper'

describe "bills/edit.html.erb" do
  before(:each) do
    @bill = assign(:bill, stub_model(Bill,
      :bill_name => "MyString",
      :bill_status => 1,
      :curr_money => "9.99",
      :house_id => 1,
      :plot_id => 1
    ))
  end

  it "renders the edit bill form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bills_path(@bill), :method => "post" do
      assert_select "input#bill_bill_name", :name => "bill[bill_name]"
      assert_select "input#bill_bill_status", :name => "bill[bill_status]"
      assert_select "input#bill_curr_money", :name => "bill[curr_money]"
      assert_select "input#bill_house_id", :name => "bill[house_id]"
      assert_select "input#bill_plot_id", :name => "bill[plot_id]"
    end
  end
end

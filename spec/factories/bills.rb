# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bill do
    bill_name "MyString"
    bill_date "2011-12-04"
    bill_status 1
    curr_money "9.99"
    house_id 1
    plot_id 1
  end
end

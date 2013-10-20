# -*- encoding : utf-8 -*-
# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bill_item do
    bill_id 1
    item_id 1
    item_name "MyString"
    money "9.99"
    trans_time "2011-12-24"
    status 1
    pay_money "9.99"
    pay_date "2011-12-24"
    house_id 1
    unit_price "9.99"
    record 1
    start_record 1
    end_record 1
    push "9.99"
    operator "MyString"
  end
end

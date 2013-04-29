# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130429031714) do

  create_table "account_details", :force => true do |t|
    t.integer  "account_id"
    t.integer  "account_type"
    t.decimal  "money",        :precision => 8, :scale => 2
    t.date     "trans_time"
    t.string   "note"
    t.string   "updateby"
    t.integer  "record"
    t.decimal  "unit_price",   :precision => 8, :scale => 2
    t.decimal  "can_push",     :precision => 8, :scale => 2, :default => 0.0
    t.integer  "receipt_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "house_id"
    t.integer  "plot_id"
    t.string   "receipt_no"
  end

  add_index "account_details", ["account_id"], :name => "index_account_details_on_account_id"

  create_table "accounts", :force => true do |t|
    t.integer  "house_id"
    t.string   "house_code"
    t.decimal  "money",      :precision => 8, :scale => 2
    t.integer  "item_id"
    t.integer  "item_type"
    t.string   "item_name"
    t.integer  "plot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "areas", :force => true do |t|
    t.string  "name"
    t.integer "house_num"
    t.integer "plot_id"
  end

  create_table "bill_items", :force => true do |t|
    t.integer  "bill_id"
    t.integer  "item_id"
    t.string   "item_name"
    t.decimal  "money",        :precision => 8, :scale => 2
    t.date     "trans_time"
    t.integer  "status"
    t.decimal  "pay_money",    :precision => 8, :scale => 2
    t.date     "pay_date"
    t.integer  "house_id"
    t.decimal  "unit_price",   :precision => 8, :scale => 2
    t.integer  "record"
    t.integer  "start_record"
    t.integer  "end_record"
    t.decimal  "push",         :precision => 8, :scale => 2
    t.string   "operator"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_type"
    t.integer  "plot_id"
    t.integer  "receipt_id"
    t.string   "receipt_no"
    t.string   "note"
  end

  create_table "bills", :force => true do |t|
    t.string   "bill_name"
    t.date     "bill_date"
    t.integer  "bill_status"
    t.decimal  "curr_money",  :precision => 8, :scale => 2
    t.integer  "house_id"
    t.integer  "plot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "charges", :force => true do |t|
    t.string   "item_name"
    t.integer  "period_type"
    t.decimal  "price",       :precision => 8, :scale => 2
    t.integer  "unit_type"
    t.integer  "item_num"
    t.integer  "period"
    t.integer  "fee_rate",                                  :default => 0
    t.integer  "return_back"
    t.string   "note"
    t.integer  "plot_id",                                                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "bind_area",                                 :default => false
  end

  add_index "charges", ["plot_id"], :name => "index_charges_on_plot_id"

  create_table "charges_houses", :id => false, :force => true do |t|
    t.integer "charge_id", :null => false
    t.integer "house_id",  :null => false
  end

  create_table "companies", :force => true do |t|
    t.string "name"
    t.string "address"
    t.string "telphone"
    t.string "email"
  end

  create_table "houses", :force => true do |t|
    t.string   "house_code"
    t.integer  "area_id",                                    :null => false
    t.decimal  "builded_area", :precision => 8, :scale => 2
    t.decimal  "real_area",    :precision => 8, :scale => 2
    t.decimal  "share_area",   :precision => 8, :scale => 2
    t.integer  "status"
    t.integer  "use_type"
    t.integer  "unit_id"
    t.integer  "plot_id",                                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "owner_name"
    t.date     "receive_time"
    t.date     "checkin_time"
  end

  add_index "houses", ["area_id"], :name => "index_houses_on_area_id"
  add_index "houses", ["plot_id"], :name => "index_houses_on_plot_id"

  create_table "owners", :force => true do |t|
    t.string   "name"
    t.integer  "age"
    t.boolean  "sex",         :default => false
    t.string   "phone"
    t.string   "id_card"
    t.string   "contract_no"
    t.integer  "house_id",                       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "owners", ["house_id"], :name => "index_owners_on_house_id"

  create_table "plots", :force => true do |t|
    t.string  "name"
    t.string  "developer"
    t.string  "constructor"
    t.string  "address"
    t.string  "phone"
    t.integer "company_id"
  end

  create_table "plots_users", :id => false, :force => true do |t|
    t.integer "plot_id", :null => false
    t.integer "user_id", :null => false
  end

  create_table "privileges", :force => true do |t|
    t.string "model_name"
    t.string "privilege"
  end

  create_table "privileges_roles", :id => false, :force => true do |t|
    t.integer "role_id",      :null => false
    t.integer "privilege_id", :null => false
  end

  create_table "receipts", :force => true do |t|
    t.string   "receipt_no"
    t.integer  "house_id"
    t.string   "house_code"
    t.integer  "plot_id"
    t.date     "print_date"
    t.string   "print_user"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "user_id", :null => false
    t.integer "role_id", :null => false
  end

  create_table "user_reports", :force => true do |t|
    t.date    "trans_time"
    t.integer "item_id"
    t.string  "item_name"
    t.integer "house_id"
    t.string  "house_code"
    t.string  "owner"
    t.decimal "pay_money",   :precision => 8, :scale => 2, :default => 0.0
    t.decimal "unpay_money", :precision => 8, :scale => 2, :default => 0.0
    t.decimal "pre_money",   :precision => 8, :scale => 2, :default => 0.0
    t.string  "operator"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                              :null => false
    t.string   "name",                               :null => false
    t.integer  "state",               :default => 1, :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email"

end

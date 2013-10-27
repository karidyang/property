# -*- encoding : utf-8 -*-
Property::Application.routes.draw do

  #report start
  match 'report/user_report', to: 'report#user_report'
  match 'report/pay_report', to: 'report#pay_report', as: 'pay_report'
  match 'report/unpay_report', to: 'report#unpay_report', as: 'unpay_report'

  # report end

  get 'receipt/print'
  get 'receipt/show'
  get 'receipt/unpay_list'

  root :to => 'home#index'
  match 'houses/house_tree' => 'houses#house_tree'
  match 'houses/hosue_info' => 'houses#house_info'
  match 'houses/info' => 'houses#info'
  match 'houses/bind_charges', :to => 'houses#add_house_charge', as: 'bind_charges'

  match 'accounts', :to => 'accounts#index'
  match 'accounts/add_pre_money/:house_id', :to => 'accounts#add_pre_money'
  match 'accounts/history/:id', :to => 'accounts#history'
  match 'accounts/delete_detail', :to => 'accounts#delete_detail'
  match 'accounts/transcation', :to => 'accounts#transcation'

  match 'charges/get_unit_price/:id', :to => 'charges#get_unit_price'
  match 'users/add_role/:id', :to => 'users#add_role', :as => 'add_user_role'
  match 'users/add_plot/:id', :to => 'users#add_plot', :as => 'add_user_plot'

  match 'bills/details/:id', :to => 'bills#details'
  match 'bills/add_temporary/:id', :to => 'bills#add_temporary'
  match 'bills/save_temporary/:id', :to => 'bills#save_temporary'
  match 'bills/reset', :to => 'bills#reset'

  match 'admin', :to => 'users#index'

  match '/profile', :to => 'home#profile', :as => 'user_profile'

  resources :bills

  resources :charges

  resources :owners

  resources :houses

  resources :roles

  resources :users

  resources :areas

  resources :plots

  resources :companies

  resources :accounts

  resources :cars, :only => [:new, :edit, :create]

  resources :car_ports

  resources :notices, :only => [:new, :edit, :create, :update, :destroy]

  match 'login', :to => 'home#login'
  match 'login_create', :to => 'home#login_create'
  match 'logout', :to => 'home#logout'
  match 'choose_plot', :to => 'home#choose_plot'
  match 'notifications', :to => 'notices#user_notice'
  match 'read_notification/:id', :to => 'notices#read_notice', :as => 'read_notification'

  match ':controller(/:action(/:id(.:format)))'
end

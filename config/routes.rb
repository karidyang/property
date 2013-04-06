Property::Application.routes.draw do
  get 'report/user_report'

  get 'receipt/print'

  get 'receipt/show'

  root :to => 'home#index'
  match 'houses/house_tree'=>'houses#house_tree'
  match 'houses/hosue_info'=>'houses#house_info'

  match 'accounts', :to => 'accounts#index'
  match 'accounts/add_pre_money/:house_id', :to=>'accounts#add_pre_money'
  match 'accounts/history/:id', :to => 'accounts#history'
  match 'accounts/delete_detail', :to => 'accounts#delete_detail'
  match 'accounts/transcation', :to => 'accounts#transcation'

  match 'charges/get_unit_price/:id', :to =>'charges#get_unit_price'
  match 'users/add_role/:id', :to=>'users#add_role'

  match 'bills/details/:id', :to => 'bills#details'
  match 'bills/add_temporary/:id', :to => 'bills#add_temporary'
  match 'bills/save_temporary/:id', :to => 'bills#save_temporary'

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

  match 'login', :to => 'home#login'
  match 'login_create', :to => 'home#login_create'
  match 'logout', :to => 'home#logout'
  match 'choose_plot', :to => 'home#choose_plot'

  match ':controller(/:action(/:id(.:format)))'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

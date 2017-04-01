Rails.application.routes.draw do
  
  get 'group_polls/index'

  get 'group_polls/create'

  get 'group_polls/vote'

  get 'group_polls/result'

  get '/user_home' => 'home#user_home'

  get 'groups' => 'groups#index'

  post 'groups' => 'groups#create'

  get 'groups/new' => 'groups#new'

  get 'groups/:id/edit' => 'groups#edit'

  patch 'groups/:id/update' => 'groups#update', :as => "group"

  put 'groups/:id/update' => 'groups#update'

  get 'groups/:id/leave' => 'groups#leave_group'

  get 'groups/:id/delete' => 'groups#delete'

  get 'groups/:id/users' => 'groups#group_users', :as => "group_users"

  get 'groups/:id/add_users' => 'groups#add_user_to_group', :as => "add_group_users"

  post 'groups/searchuser' => 'groups#search_json'

  post '/add_user' => 'groups#add_user'

  post '/remove_user' => 'groups#remove_user'

  get 'home/index'

  get 'group/:id/show' => 'home#group' 

  get 'user_json' => 'home#user_json'

  devise_for :users, :controllers => { registrations: 'users/registrations', sessions: 'users/sessions'}
  
  root to: "home#index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

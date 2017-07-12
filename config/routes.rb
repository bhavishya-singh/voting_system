Rails.application.routes.draw do
  
  get 'image/new'

  get 'image/create'

  get 'image/edit'

  get 'image/update'

  get 'group_polls/index'

  get 'group_polls/:group_id/new' => "group_polls#new", as: "new_poll"

  post 'group_polls/create' => "group_polls#create"

  post 'group_polls/create_asyncronously' => "group_polls#create_async"

  get 'group_polls/:group_poll_id/vote' => 'group_polls#vote'

  get 'group_polls/:group_poll_id/stop_poll' => 'group_polls#stop_poll', :as => "stop_poll"

  get 'group_polls/:group_poll_id/result' => 'group_polls#result'

  post 'contribute' => 'group_polls#contribute'

  get 'group_polls/:group_poll_id/delete_user' => 'group_polls#delete_group_poll_for_user', as: "delete_poll"

  get 'unipoll/:uni_poll_id/vote' => 'uni_poll#vote'

  get 'unipoll/:uni_poll_id/result' => 'uni_poll#result'

  get 'unipoll/:uni_poll_id/stop_poll' => 'uni_poll#stop_poll',:as => 'stop_public_poll'

  post '/public_poll_contribute' => 'uni_poll#contribute'

  get 'unipoll/new' => 'uni_poll#new'

  post 'unipoll/create' => 'uni_poll#create'

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

  get '/user_home' => 'home#user_home'

  get 'home/index'

  get 'group/:id/show' => 'home#group' 

  get 'user_json' => 'home#user_json'

  get '/autocomplete_user_user_name' => 'home#autocomplete_user_user_name'

  get '/user/registrations-facebook' => 'facebook_registrations#new'

  post '/user/registrations-facebook/create' => 'facebook_registrations#create'

  mount Resque::Server, :at => "/resque"
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks", registrations: 'users/registrations', sessions: 'users/sessions'}
  
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

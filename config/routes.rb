Ebentum::Application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    match '/users/facebook_login' => 'users/omniauth_callbacks#facebook_login'
    match '/users/twitter_login'  => 'users/omniauth_callbacks#twitter_login'
    match '/auth_login/callback'  => 'users/omniauth_callbacks#facebook'
  end

  resources :activities

  resources :welcome

  match 'events/add_user/:eventid'    => 'events#add_user'
  match 'events/remove_user/:eventid' => 'events#remove_user'
  match 'events/search'               => 'events#search'
  resources :events
  resources :tokens
  match '/social/share_event_appoint' => 'social#share_event_appoint'
  match '/social/get_social_data'     => 'social#get_social_data'
  resources :social
  resources :comments
  resources :pictures

  resources :users do
    member do
      get :following, :followers, :created_events, :events
      put :follow, :unfollow
    end
  end

  


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
  root :to => 'activities#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end

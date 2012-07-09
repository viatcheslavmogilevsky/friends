Friends::Application.routes.draw do

  get "user_friendships/accept"

  get "user_friendships/cancel"

  devise_for :users

  root :to => "home#index"
  match 'feed' => "home#feed", :as => :feed 
  match 'profile' => "home#profile", :as => :profile
  match 'dialogues' => "home#dialogues", :as => :dialogues
  match 'photos' => "home#photos", :as => :photos
  match 'friends' => "home#friends", :as => :friends
  resources :users, :only => [:show,:index] do
    get 'search', :on => :collection 
    delete 'delete', :on => :member
    post 'create_invite', :on => :member
  end

  resources :user_friendships, :only => [] do
    member do
      put 'accept'
      delete 'cancel'
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end

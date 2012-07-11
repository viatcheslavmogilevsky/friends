Friends::Application.routes.draw do

  devise_for :users

  root :to => "home#index"
  match 'feed' => "home#feed", :as => :feed 
  match 'profile' => "home#profile", :as => :profile
  match 'inbox' => "home#inbox", :as => :inbox
  match 'outbox' => "home#outbox", :as => :outbox
  match 'friends' => "home#friends", :as => :friends
  match 'notifications' => "home#notifications", :as => :notifications
  resources :users, :only => [:show,:index] do
    get 'search', :on => :collection 
    member do
      delete 'delete'
      post 'create_invite'
      get 'dialog'
      post 'send_message'
      get 'new_message'
    end
    resources :photo_albums
    resources :posts, :only => [:create]
    resources :photos, :only => [:index]
  end

  resources :photo_albums, :only => [] do
    resources :photos, :only => [:new,:create]
  end

  resources :photos, :except => [:new,:create,:index] do
    put :toggle_like, :on => :member
    resources :comments,  :except => [:new, :index, :show] do
      put :toggle_like, :on => :member
    end
  end

  resources :user_friendships, :only => [] do
    member do
      put 'accept'
      delete 'cancel'
    end  
  end

  resources :messages, :only => [:show] do
    put 'mark_to_delete', :on => :member
  end

  resources :posts, :except => [:new, :index] do
    resources :comments, :except => [:new, :index, :show], :in_post => true do
      put :toggle_like, :on => :member
    end
    put :toggle_like, :on => :member
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

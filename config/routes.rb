Watches::Application.routes.draw do  
  get "users/show"
  get "users/update"

  resources :brands, :only => %w(index show)

  get "administrator/orders"
  get "administrator", :to => 'administrator#orders'

  resources :item_models
  
  match 'guarantee', :to => 'static#guarantee', :as => 'guarantee'
  match 'payments', :to => 'static#payments', :as => 'payments'
  match 'deliveries', :to => 'static#deliveries', :as => 'deliveries'
  match 'contacts', :to => 'static#contacts', :as => 'contacts'
  match 'about_us', :to => 'static#about_us', :as => 'about_us'

  match 'search', :to => 'item_models#search', :as => 'search'
  match 'checkout', :to => 'shopping_cart#show', :as => 'checkout'

  post "comments/create", :as => 'new_comment'
  match "comments/destroy/:comment_id", :to => 'comments#destroy', :as => 'destroy_comment'
  devise_for :users, :path_names => { 
    :sign_up => 'register', 
    :sign_in => 'login' 
  }, :controllers => { 
    :registrations => "users/registrations", 
    :passwords => "users/passwords"
  }, :path_prefix => 'd'
  
  resources :users
  
  match 'add/:product_id', :to => 'shopping_cart#add_to_cart', :as => 'add'

  post 'payment', :to => 'shopping_cart#payment', :as => 'payment'
  post 'create_order', :to => 'shopping_cart#create_order', :as => 'create_order'
  post 'review', :to => 'shopping_cart#review', :as => 'review'
  post 'change_quantity/:cart_line_id', :to => 'shopping_cart#change_quantity', :as => 'change_quantity'
  post 'remove_cart_line/:cart_line_id', :to => 'shopping_cart#remove_cart_line', :as => 'remove_cart_line'
  get "item_models/:id", :to => "item_models#show"


  match 'preload', :to => 'item_models#preload', :as => 'preload'
  root :to => 'item_models#index'
end

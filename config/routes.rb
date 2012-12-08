Watches::Application.routes.draw do  

  get "users/show"
  get "users/update"

  resources :brands, :only => %w(index show)
  resources :categories, :only => %w(show)

  get "administrator", :to => 'administrator#orders'
  namespace :administrator do
    get "orders"
    get "login"
    post "do_login"
    get "static_pages"
    post "change_static_page"
    get "exchange_rates"
    post "change_exchange_rate"
    get "category_translates"
    post "category_translate"
    get "brand_translates"
    post "brand_translate"
    get "brand_favorites"
    post "set_brand_favorite"
    get "category_favorites"
    post "set_category_favorite"
    get "sub_category_favorites"
    post "set_sub_category_favorite"
    get "category_mapping"
    post "set_category_mapping"
    get "reviews"
    post "verify_review"
  end

  namespace :search do
    get "index"
    get "load_items"
    get "preload_categories"
    get "preload_sub_categories"
    get "preload_brands"
    get "preload_genders"
    get "preload_sizes"
    get "preload_colors"
    get "preload_facet_list"
  end

  resources :item_models
  
  #match 'reviews', :to => 'reviews#index', :as => 'reviews'
  resources :reviews, :only => %w(index create)
  match 'payments', :to => 'static#payments', :as => 'payments'
  match 'deliveries', :to => 'static#deliveries', :as => 'deliveries'
  match 'contacts', :to => 'static#contacts', :as => 'contacts'
  match 'about_us', :to => 'static#about_us', :as => 'about_us'

  match 'search', :to => 'item_models#search', :as => 'search'
  match 'checkout', :to => 'shopping_cart#show', :as => 'checkout'

  post "comments/create", :as => 'new_comment'
  match "comments/destroy/:comment_id", :to => 'comments#destroy', :as => 'destroy_comment'

  get 'advanced_search', :to => 'search#index'
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

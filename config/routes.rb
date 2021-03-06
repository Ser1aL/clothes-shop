Watches::Application.routes.draw do

  constraints :format => // do
    resources :articles, only: %w(index show)

    get 'users/show'
    get 'users/update'

    resources :brands, :only => %w(index show) do
      get 'letter/:letter', :to => 'brands#index', :on => :collection, :as => 'letter'
    end

    get 'c/:top_level_cat_id', to: 'categories#show', as: 'category'
    get 'c/:top_level_cat_id/:brand', to: 'categories#show', as: 'category_brand'
    get 'c/:top_level_cat_id/g/:gender', to: 'categories#show', as: 'category_gender'
    get 'c/:top_level_cat_id/g/:gender/sub/:category', to: 'categories#show', as: 'category_gender_sub_category'
    get 'c/:top_level_cat_id/g/:gender/b/:brand', to: 'categories#show', as: 'category_gender_brand'
    get 'c/:top_level_cat_id/s/:category', to: 'categories#show', as: 'category_sub_category'
    get 'c/:top_level_cat_id/s/:category/:brand', to: 'categories#show', as: 'category_sub_category_with_brand'
    get 'c/:top_level_cat_id/s/:category/b/:brand/sub/:sub_category', to: 'categories#show', as: 'category_sub_category_with_brand_and_sub'
    get 'c/:top_level_cat_id/s/:category/sub/:sub_category', to: 'categories#show', as: 'category_sub_category_with_sub'

    resources :sitemaps, :only => %w(index)

    namespace :search do
      get 'index'
      get 'load_items'
      get 'preload_categories'
      get 'preload_sub_categories'
      get 'preload_brands'
      get 'preload_genders'
      get 'preload_sizes'
      get 'preload_colors'
      get 'preload_facet_list'
    end


    resources :item_models
    get 'product/:id/:style_id', :to => 'item_models#show', :as => 'single_model'

    #match 'reviews', :to => 'reviews#index', :as => 'reviews'
    resources :reviews, :only => %w(index create)
    match 'payments', :to => 'static#payments', :as => 'payments'
    match 'deliveries', :to => 'static#deliveries', :as => 'deliveries'
    match 'contacts', :to => 'static#contacts', :as => 'contacts'
    match 'about-us', :to => 'static#about_us', :as => 'about_us'


    match 'search', :to => 'item_models#search', :as => 'search'
    match 'checkout', :to => 'shopping_cart#show', :as => 'checkout'

    post 'comments/create', :as => 'new_comment'
    match 'comments/destroy/:comment_id', :to => 'comments#destroy', :as => 'destroy_comment'

    get 'advanced_search', :to => 'search#index'
    devise_for :users, :path_names => {
        :sign_up => 'register',
        :sign_in => 'login'
    }, :controllers => {
        :registrations => 'users/registrations',
        :passwords => 'users/passwords'
    }, :path_prefix => 'd'

    resources :users

    match 'add/:product_id', :to => 'shopping_cart#add_to_cart', :as => 'add'
    post '/order_call', to: 'shopping_cart#order_call', as: 'order_call'

    post 'payment', :to => 'shopping_cart#payment', :as => 'payment'
    post 'create_order', :to => 'shopping_cart#create_order', :as => 'create_order'
    post 'review', :to => 'shopping_cart#review', :as => 'review'
    post 'change_quantity/:cart_line_id', :to => 'shopping_cart#change_quantity', :as => 'change_quantity'
    post 'remove_cart_line/:cart_line_id', :to => 'shopping_cart#remove_cart_line', :as => 'remove_cart_line'
    match 'mark_callback', :to => 'shopping_cart#mark_callback', :as => 'mark_callback'
    get 'item_models/:id', :to => 'item_models#show'

    get 'administrator', :to => 'administrator#orders'
    post 'administrator/set_order_status/:order_id', :to => 'administrator#set_order_status', :as => :administrator_set_order_status
    get 'administrator/edit_article/:id', to: 'administrator#edit_article', :as => :administrator_edit_article
    get 'administrator/seo_pages_remove/:id', to: 'administrator#seo_pages_remove', :as => :administrator_seo_pages_remove
    namespace :administrator do
      get 'orders'
      get 'login'
      post 'do_login'
      get 'static_pages'
      post 'change_static_page'
      get 'exchange_rates'
      post 'change_exchange_rate'
      get 'category_translates'
      post 'category_translate'
      get 'brand_translates'
      post 'brand_translate'
      get 'brand_favorites'
      post 'set_brand_favorite'
      get 'category_favorites'
      post 'set_category_favorite'
      get 'sub_category_favorites'
      post 'set_sub_category_favorite'
      get 'category_mapping'
      post 'set_category_mapping'
      get 'reviews'
      post 'verify_review'
      get 'six_pm'
      get 'articles'
      post 'create_article'
      post 'update_article'
      get 'seo_pages'
      post 'seo_pages_create'
    end

    match '/404', to: 'errors#not_found'
    match '/500', to: 'errors#internal_server_error'

    match 'preload', :to => 'item_models#preload', :as => 'preload'
  end


  root :to => 'item_models#index'
end

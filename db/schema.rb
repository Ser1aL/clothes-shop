# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131208110012) do

  create_table "addresses", :force => true do |t|
    t.integer  "user_id"
    t.string   "country"
    t.string   "city"
    t.string   "line1"
    t.string   "phone1"
    t.string   "phone2"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "short_description"
    t.text     "description"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "banners", :force => true do |t|
    t.integer  "category_id"
    t.string   "url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "image_url"
    t.string   "side"
  end

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "external_brand_id"
    t.string   "logo_url"
    t.string   "display_name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.boolean  "favorite"
  end

  add_index "brands", ["name"], :name => "index_brands_on_name"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "display_name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.boolean  "favorite"
    t.integer  "top_category"
  end

  add_index "categories", ["name"], :name => "index_categories_on_name"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.string   "association_id"
    t.string   "association_type"
    t.text     "body"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "countings", :force => true do |t|
    t.integer  "category_id"
    t.integer  "sub_category_id"
    t.integer  "brand_id"
    t.integer  "gender_id"
    t.integer  "value"
    t.string   "category_name"
    t.string   "sub_category_name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "gender_name"
    t.string   "brand_name"
  end

  create_table "exchange_rates", :force => true do |t|
    t.decimal  "value",        :precision => 10, :scale => 2
    t.decimal  "markup",       :precision => 10, :scale => 2
    t.string   "currency"
    t.string   "domain"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "fixed_markup"
  end

  create_table "genders", :force => true do |t|
    t.string   "name"
    t.string   "display_name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "image_attachments", :force => true do |t|
    t.integer  "association_id"
    t.string   "association_type"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "image_url"
    t.string   "external_image_type"
    t.boolean  "is_zoomed"
  end

  add_index "image_attachments", ["association_id"], :name => "index_image_attachments_on_association_id"

  create_table "item_models", :force => true do |t|
    t.integer  "brand_id"
    t.integer  "category_id"
    t.integer  "sub_category_id"
    t.integer  "gender_id"
    t.text     "description"
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
    t.string   "external_product_id"
    t.string   "product_name"
    t.string   "video_url"
    t.string   "weight"
    t.string   "txAttrFacet_Materials"
    t.string   "txAttrFacet_Verticals"
    t.string   "txAttrFacet_Closures"
    t.string   "txAttrFacet_Occasion"
    t.string   "txAttrFacet_Performance"
    t.string   "txAttrFacet_Styles"
    t.string   "txAttrFacet_Features"
    t.string   "txAttrFacet_StraporHandleStyle"
    t.string   "txAttrFacet_Promo"
    t.string   "txAttrFacet_Theme"
    t.string   "txAttrFacet_Care"
    t.string   "txAttrFacet_SwimsuitStyles"
    t.string   "txAttrFacet_ShortsInseam"
    t.string   "txAttrFacet_Pattern"
    t.string   "txAttrFacet_PantStyles"
    t.string   "txAttrFacet_JeansFit"
    t.string   "txAttrFacet_Accents"
    t.string   "txAttrFacet_Pockets"
    t.string   "txAttrFacet_DenimType"
    t.string   "txAttrFacet_Rise"
    t.string   "txAttrFacet_SkirtStyles"
    t.string   "txAttrFacet_Insole"
    t.string   "txAttrFacet_Lining"
    t.string   "txAttrFacet_ShoeToeStyle"
    t.string   "txAttrFacet_BootShaft"
    t.string   "txAttrFacet_ShoeWeight"
    t.string   "txAttrFacet_WaterResistance"
    t.string   "txAttrFacet_FaceShape"
    t.string   "txAttrFacet_Display"
    t.string   "txAttrFacet_Trend"
    t.string   "txAttrFacet_HatTypes"
    t.string   "txAttrFacet_Gender"
    t.string   "txAttrFacet_TopStyles"
    t.string   "txAttrFacet_CollarStyle"
    t.string   "txAttrFacet_CountryofOrigin"
    t.string   "txAttrFacet_HeelStyle"
    t.string   "txAttrFacet_SleeveLength"
    t.string   "txAttrFacet_UnderwearStyles"
    t.string   "txAttrFacet_BraType"
    t.string   "txAttrFacet_WeddingParty"
    t.string   "txAttrFacet_SkirtLength"
    t.string   "txAttrFacet_ShortStyles"
    t.string   "txAttrFacet_DressTypes"
    t.string   "txAttrFacet_SpecialtySizes"
    t.string   "txAttrFacet_BagFrames"
    t.string   "txAttrFacet_SockLengths"
    t.string   "txAttrFacet_ProductCompatibility"
    t.string   "txAttrFacet_SockStyles"
    t.string   "txAttrFacet_FitAssist"
    t.string   "txAttrFacet_PerformanceShoeSupportType"
    t.string   "txAttrFacet_JacketTypes"
    t.string   "txAttrFacet_Fill"
    t.string   "txAttrFacet_BagSize"
    t.string   "txAttrFacet_Movement"
    t.string   "txAttrFacet_Treatments"
    t.boolean  "facet_loaded",                           :default => false
    t.string   "origin"
  end

  add_index "item_models", ["brand_id"], :name => "index_item_models_on_brand_id"
  add_index "item_models", ["category_id"], :name => "index_item_models_on_category_id"
  add_index "item_models", ["external_product_id"], :name => "index_item_models_on_external_product_id"
  add_index "item_models", ["gender_id"], :name => "index_item_models_on_gender_id"
  add_index "item_models", ["product_name"], :name => "index_item_models_on_product_name"
  add_index "item_models", ["sub_category_id"], :name => "index_item_models_on_sub_category_id"

  create_table "meta_rewrites", :force => true do |t|
    t.string   "path"
    t.text     "title"
    t.text     "description"
    t.text     "header"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "text_partial"
    t.text     "raw_text"
  end

  create_table "order_lines", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.integer  "style_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.decimal  "price",      :precision => 10, :scale => 2
    t.string   "currency"
    t.string   "stock_size"
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.datetime "order_time"
    t.string   "status"
    t.boolean  "reviewed",                                     :default => false
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
    t.decimal  "total",         :precision => 10, :scale => 2
    t.string   "city"
    t.string   "address"
    t.string   "country"
    t.string   "callback"
    t.string   "delivery_city"
  end

  create_table "products", :force => true do |t|
    t.integer  "total_quantity"
    t.integer  "item_model_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "products", ["item_model_id"], :name => "index_products_on_item_model_id"

  create_table "reviews", :force => true do |t|
    t.text     "body"
    t.string   "name"
    t.string   "email"
    t.boolean  "verified"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shopping_cart_lines", :force => true do |t|
    t.integer  "product_id"
    t.integer  "shopping_cart_id"
    t.integer  "quantity"
    t.integer  "style_id"
    t.decimal  "price",            :precision => 10, :scale => 2
    t.string   "currency"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.string   "stock_size"
  end

  create_table "shopping_carts", :force => true do |t|
    t.integer  "user_id"
    t.string   "status",     :default => "open"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "static_pages", :force => true do |t|
    t.string   "name"
    t.string   "human_name"
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "stocks", :force => true do |t|
    t.string   "size"
    t.string   "width"
    t.integer  "quantity"
    t.string   "external_stock_id"
    t.integer  "style_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "stocks", ["style_id"], :name => "index_stocks_on_style_id"

  create_table "styles", :force => true do |t|
    t.string   "color"
    t.decimal  "discount_price",    :precision => 10, :scale => 2
    t.decimal  "original_price",    :precision => 10, :scale => 2
    t.integer  "product_id"
    t.integer  "percent_off"
    t.string   "external_style_id"
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.boolean  "on_sale"
    t.integer  "external_color_id"
    t.boolean  "hidden",                                           :default => false
    t.string   "swatch_url"
  end

  add_index "styles", ["color"], :name => "index_styles_on_color"
  add_index "styles", ["discount_price"], :name => "index_styles_on_discount_price"
  add_index "styles", ["product_id"], :name => "index_styles_on_product_id"

  create_table "sub_categories", :force => true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.string   "display_name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.boolean  "favorite"
  end

  add_index "sub_categories", ["name"], :name => "index_sub_categories_on_name"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "middle_name"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "phone_number"
    t.string   "address"
    t.string   "city"
    t.string   "country"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end

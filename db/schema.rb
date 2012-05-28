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

ActiveRecord::Schema.define(:version => 20120528165145) do

  create_table "addresses", :force => true do |t|
    t.integer  "user_id"
    t.string   "country"
    t.string   "city"
    t.string   "line1"
    t.string   "phone1"
    t.string   "phone2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "banners", :force => true do |t|
    t.integer  "category_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "external_brand_id"
    t.string   "logo_url"
    t.string   "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "favorite"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.string   "association_id"
    t.string   "association_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countings", :force => true do |t|
    t.integer  "category_id"
    t.integer  "sub_category_id"
    t.integer  "brand_id"
    t.integer  "gender_id"
    t.integer  "value"
    t.string   "category_name"
    t.string   "sub_category_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exchange_rates", :force => true do |t|
    t.decimal  "value",      :precision => 10, :scale => 2
    t.decimal  "markup",     :precision => 10, :scale => 2
    t.string   "currency"
    t.string   "domain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genders", :force => true do |t|
    t.string   "name"
    t.string   "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "image_attachments", :force => true do |t|
    t.integer  "association_id"
    t.string   "association_type"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "image_file_size"
    t.string   "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "image_attachments", ["association_id"], :name => "index_image_attachments_on_association_id"

  create_table "item_models", :force => true do |t|
    t.integer  "brand_id"
    t.integer  "category_id"
    t.integer  "sub_category_id"
    t.integer  "gender_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "external_product_id"
    t.string   "product_name"
    t.string   "video_url"
    t.string   "weight"
  end

  create_table "order_lines", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.integer  "style_id"
    t.integer  "stock_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "price",      :precision => 10, :scale => 2
    t.string   "currency"
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.datetime "order_time"
    t.enum     "status",     :limit => [:submitted, :paid, :sent]
    t.boolean  "reviewed",                                                                        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "total",                                            :precision => 10, :scale => 2
    t.string   "city"
    t.string   "address"
    t.string   "country"
  end

  create_table "products", :force => true do |t|
    t.integer  "total_quantity"
    t.integer  "item_model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shopping_cart_lines", :force => true do |t|
    t.integer  "product_id"
    t.integer  "shopping_cart_id"
    t.integer  "quantity"
    t.integer  "style_id"
    t.integer  "stock_id"
    t.decimal  "price",            :precision => 10, :scale => 2
    t.string   "currency"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shopping_carts", :force => true do |t|
    t.integer  "user_id"
    t.enum     "status",     :limit => [:open, :close], :default => :open
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "static_pages", :force => true do |t|
    t.string   "name"
    t.string   "human_name"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stocks", :force => true do |t|
    t.string   "size"
    t.string   "width"
    t.integer  "quantity"
    t.string   "external_stock_id"
    t.integer  "style_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stocks", ["style_id"], :name => "index_stocks_on_style_id"

  create_table "styles", :force => true do |t|
    t.string   "color"
    t.decimal  "discount_price",    :precision => 10, :scale => 2
    t.decimal  "original_price",    :precision => 10, :scale => 2
    t.integer  "product_id"
    t.integer  "percent_off"
    t.string   "external_style_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "on_sale"
  end

  add_index "styles", ["product_id"], :name => "index_styles_on_product_id"

  create_table "sub_categories", :force => true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.string   "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "middle_name"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number"
    t.string   "address"
    t.string   "city"
    t.string   "country"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end

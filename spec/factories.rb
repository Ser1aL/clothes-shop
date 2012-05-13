FactoryGirl.define do

  factory :brand do
    name 'Pier Cardin'
  end

  factory :category do
    name 'Male'
  end

  factory :sub_category do
    name 'Classic'
  end

  factory :color do
    name 'Automatic'
  end

  factory :address do
    country 'Ukraine'
    city 'Odessa'
    phone1 '111-222-33'
    phone2 '067(123-123-12)'
    line1 'Gukovskogo, 15'
    user_id 1
  end

  factory :clock_model do
    model_unique_number 'Pierre Cardin'
    brand_id 1
    category_id 1
    sub_category_id 1
    color_id 1
    watch_case 'Pierre Cardin'
    strap 'Pierre Cardin'
    clock_face 'Pierre Cardin'
    color 'Pierre Cardin'
  end

  factory :product do
    price 22.11
    quantity 2
    clock_model_id 1
    order_lines []
  end

  factory :order_line do
    order_id 1
    association :product, :factory => :product
    quantity 2
  end

  factory :order do
    user_id 1
    order_time Time.now
    delivery_type "postal_service"
    status "paid"
    order_lines [Factory.build(:order_line)]
  end


  factory :image_attachment do
    association_id = 1
  end

  factory :user do
    sequence(:email) { |n| "example_#{n}@email_server.do" }
    password "secret"
    first_name "Max"
    last_name "Reznichenko"
    password_confirmation "secret"
    addresses [Factory.build(:address), Factory.build(:address)]
  end

  factory :shopping_cart_line do
    product Factory(:product)
    shopping_cart_id 1
    quantity 2
    price 11.22
  end

  factory :shopping_cart do
    shopping_cart_lines [Factory.build(:shopping_cart_line)]
    user Factory.build(:user)
    created_at Time.now
  end

  factory :comment do
    user_id 1
    association_id 2
    body 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum'
    
  end
end















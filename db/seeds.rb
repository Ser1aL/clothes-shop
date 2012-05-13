SubCategory.create!(:name => 'Little small bags')
SubCategory.create!(:name => 'Tiny goodie shoes')

Category.create!(:name => "Bags")
Category.create!(:name => "Shoes")

Color.create!(:name => "Blue")
Color.create!(:name => "Yellow")

1.times do |m|
  brand = Brand.create(:name => "Adidas_#{m}")
  25.times do |n|
    model = ItemModel.create(
      :brand => brand,
      :category_id => (n % 2 == 0 ? 1 : 2),
      :sub_category_id => (n % 2 == 0 ? 1 : 2),
      :color_id => (n % 2 == 0 ? 1 : 2)
    )
    image = ImageAttachment.new
    image.image_from_url "http://a1.zassets.com/images/z/1/6/6/4/8/6/1664865-p-4x.jpg"
    model.image_attachments << image
    model.save
    Product.create(:original_price => (m+1)*(n+1)/2*13/22, :discount_price => (m+1)*(n+1)/2*13/23, :quantity => 10, :item_model => model)
  end
end

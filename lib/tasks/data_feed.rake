namespace :data_feed do

  client = Zappos::Client.new("9a3e643501faa5feecc03ea9d1ec1fdf9217dcf1", { :base_url => 'api.zappos.com' })
  limit = 100

  search_opts = {
    :term => "clothes",
    :limit => limit,
    :includes => %w(categoryFacet txAttrFacet_Gender),
    :excludes => %w(styleId colorId productUrl thumbnailImageUrl percentOff)
  }

  product_search_opts = {
    :includes => %w(gender weight videoUrl styles sortedSizes styles stocks),
    :excludes => %w(productId brandName productName defaultImageUrl defaultProductUrl )
  }

  desc "fetches 'clothes' items from remote api"
  task :clothes => :environment do
    # total_count = client.search(:term => "clothes", :limit => 1).totalResultCount.to_f
    total_count = limit

    (total_count/limit).ceil.times do |index|
      items = client.search( search_opts.merge!({:page => index + 1}) ).results

      items.each do |item|
        next if ItemModel.find_by_external_product_id(item.productId)

        product = client.product( product_search_opts.merge!({:id => item.productId}) ).data.product.first
        styles = product.styles

        item_model = ItemModel.create(
          :external_product_id => item.productId,
          :product_name => item.productName,
          :gender => product.gender,
          :brand => Brand.find_or_create_by_name(item.brandName),
          :category => Category.find_or_create_by_name("Clothes"),
          :sub_category => SubCategory.find_or_create_by_name(item.categoryFacet),
          :color => Color.find_or_create_by_name("undefined"),
          :weight => product.weight,
          :video_url => product.videoUrl
        )

        product_model = Product.create(
          :item_model => item_model,
          :avg_original_price => 0.0,
          :avg_discount_price => 0.0,
          :total_quantity => 0
        )

        styles.each do |style_feed|
          style = Style.create(
            :color => style_feed.color,
            :original_price => style_feed.originalPrice[1..-1].to_f,
            :discount_price => style_feed.price[1..-1].to_f,
            :product => product_model,
            :external_style_id => style_feed.styleId
          )
          style.image_attachments.create(:image => open(style_feed.imageUrl))

          style_feed.stocks.each do |stock|
            Stock.create(
              :size => stock['size'],
              :quantity => stock.onHand,
              :width => stock.width,
              :external_stock_id => stock.stockId,
              :style => style
            )
          end
        end

      end
    end
  end

end
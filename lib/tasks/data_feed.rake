require 'open-uri'

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
    :includes => %w(gender description weight videoUrl styles sortedSizes styles stocks onSale),
    :excludes => %w(productId brandName productName defaultImageUrl defaultProductUrl )
  }

  brand_search_opts = {
    :includes => %w(aboutText),
    :excludes => %w(name cleanName brandUrl)
  }

  image_search_opts = {
    :recipe => %w(MULTIVIEW),
    :excludes => %w(type format productId recipeName imageId styleId)
  }

  price_search_opts = {
    :includes => %w(styles stocks onSale),
    :excludes => %w(imageUrl color productUrl brandId brandName productName defaultProductUrl defaultImageUrl productId)
  }

  desc "fetches 'item_models' from remote api"
  task :item_models => :environment do
    terms = %w(Clothes Bags Accessories Shoes Sunglasses)
    terms.each do |term|
      begin
        response = client.search(:term => term, :limit => 1)

        # debugging response
        p response

        total_count = response.totalResultCount.to_f

        (total_count.to_f/limit.to_f).ceil.times do |index|
          begin
            items = client.search( search_opts.merge!({:page => index + 1, :term => term.downcase}) ).results

            items.each do |item|
              next if ItemModel.find_by_external_product_id(item.productId)

              product = client.product( product_search_opts.merge!({:id => item.productId}) ).data.product.first
              brand = Brand.find_by_external_brand_id(product.brandId)
              image_feed = client.image( image_search_opts.merge!({:productId => item.productId})).data.images

              unless brand
                brand_feed = client.brand(brand_search_opts.merge!({:id => product.brandId})).data.brands.first
                brand = Brand.create(
                  :name => item.brandName,
                  :description => brand_feed.aboutText,
                  :external_brand_id => product.brandId,
                  :logo_url => brand_feed.headerImageUrl
                )
                brand.image_attachments.create(:image => open(brand_feed.imageUrl))
              end

              styles = product.styles
              description = Nokogiri::XML(product.description)
              description.search("ul li a").each(&:remove)
              item_model = ItemModel.create(
                :external_product_id => item.productId,
                :product_name => item.productName,
                :brand => brand,
                :category => Category.find_or_create_by_name(term),
                :sub_category => SubCategory.find_or_create_by_name(item.categoryFacet),
                :gender => Gender.find_or_create_by_name(product.gender),
                :description => description.to_s,
                :weight => product.weight,
                :video_url => product.videoUrl
              )

              product_model = Product.create(
                :item_model => item_model,
                :total_quantity => 0
              )

              styles.each do |style_feed|
                style = Style.create(
                  :color => style_feed.color,
                  :original_price => style_feed.originalPrice[1..-1].to_f,
                  :discount_price => style_feed.price[1..-1].to_f,
                  :product => product_model,
                  :percent_off => style_feed.percentOff.to_i,
                  :external_style_id => style_feed.styleId,
                  :on_sale => style_feed.onSale == "true"
                )
                image_feed[style_feed.styleId].each do |image|
                  style.image_attachments.create(:image => ImageAttachment.image_from_url(image.filename))
                end

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
              puts "#{item_model.product_name} loaded. Id ##{item_model.id}"
            end
          rescue => error
            puts "Error in loop"
            logger.debug error.inspect
          end
        end
      rescue => error
        puts "Error in overall"
        p error
        sleep 300
        retry
      end
    end
  end

  desc "updates item model prices"
  task :update_prices => :environment do
    ItemModel.with_price_not_updated.each do |item_model|
      price_feed = client.product( price_search_opts.merge!({:id => item_model.external_product_id}) ).data.product.first
      item_model.product.styles.each do |style|

        # secondary check for multi run
        next if style.updated_at > Time.now - ItemModel::PRICE_UPDATE_INTERVAL

        price_feed.styles.each do |style_feed|
          if style_feed.styleId == style.external_style_id
            style.update_attributes(
              :original_price => (style_feed.originalPrice[1..-1].to_f * ExchangeRate.first.value.to_f).to_i,
              :discount_price => (style_feed.price[1..-1].to_f * ExchangeRate.first.value.to_f).to_i,
              :percent_off => style_feed.percentOff.to_i,
              :updated_at => Time.now,
              :on_sale => style_feed.onSale == "true"
            )
            style.stocks.destroy_all
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

  desc "load banners"
  task :load_banners => :environment do
    root_page = "http://6pm.com"
    # database name => 6pm page
    category_mapping = {
        :clothes => 'clothing',
        :bags => 'bags',
        :accessories => 'accessories',
        :shoes => 'shoes',
        :sunglasses => 'sunglasses',
        :index => ''
    }
    category_mapping.each do |category_name, page_name|
      if category = Category.find_by_name(category_name) || category_name == :index
        if category_name != :index
          category.banners.destroy_all
        else
          Banner.where("banners.category_id IS NULL").destroy_all
        end

        nokogiri_page = Nokogiri::HTML(open("#{root_page}/#{page_name}"))
        nokogiri_page.css(".baffinGallery a img").map{|element| element.attributes["src"].to_s}.each do |image_link|

          banner = category_name == :index ? Banner.create : category.banners.create
          banner.image_attachments.create(:image => ImageAttachment.image_from_url("#{root_page}#{image_link}"))
        end
      end
    end

  end
end

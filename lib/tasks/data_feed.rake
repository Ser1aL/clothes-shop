require 'open-uri'
require 'cgi'

namespace :data_feed do

  key_list = %w(
    8bffaa3d5e1ccb6857544756293cf624f7d371d7
    3ae517aa832c98fc1d47c6d9d4669f05a5bda4cb
    1c256e0d9206018da4c6b574f4a7727369a821e6
    9a3e643501faa5feecc03ea9d1ec1fdf9217dcf1
    2d2df9b711b7950424b08be13736befc36071c1
    103a337b8da9bf07a2fbeaf1174863355578db20
    bd681f5813fecc01125f4b170139e7dbb5f57650
    806db79102d01b43100880d34187d5ebd79dda6c
    5f60e9616ce4dc1def1be1a9d4e5edb052bc5e2d
    611c3a7ab7dd6cc24c8eecf3d914a21511e549e3
    4fd6ec8ee757905d08c6b0e063ee53a3277d9903
    b9b79a15b2c0efeaa17e18d5d9ff1c0ba7f0fceb
    682e77c7447636780d5679a9bf6aa95c512e906c
    73d48a44f5aa34630603867d6f713214757581f
    36145a18b8611ac955474b3cace251fc724d779b
    9fb8ecbdd912c0207da2bac17de16eb631db70ae
  )
  current_product_limit = 8000000

  search_opts = {
    :limit => 100,
    :includes => %w(categoryFacet txAttrFacet_Gender),
    :excludes => %w(styleId colorId productUrl thumbnailImageUrl percentOff)
  }

  product_search_opts = {
    :includes => %w(gender description weight videoUrl styles sortedSizes styles stocks onSale defaultCategory defaultSubCategory colorId),
    :excludes => %w(productId brandName productName defaultImageUrl defaultProductUrl )
  }

  brand_search_opts = {
    :includes => %w(aboutText),
    :excludes => %w(name cleanName brandUrl)
  }

  image_search_opts = {
    :recipe => %w(MULTIVIEW 4x),
    :excludes => %w(format productId imageId styleId)
  }

  price_search_opts = {
    :includes => %w(styles stocks onSale),
    :excludes => %w(imageUrl color productUrl brandId brandName productName defaultProductUrl defaultImageUrl productId)
  }

  facet_search_opts = {
    :includes => %w(attributeFacetFields),
    :excludes => %w(defaultProductUrl productName defaultImageUrl productId brandName brandId)
  }

  desc "fetches 'item_models' from remote api"
  task :item_models => :environment do

    # ActiveRecord::Base.logger = Logger.new STDOUT

    start_from_page = ENV['start_from_page'].blank? ? 0 : ENV['start_from_page']
    key_index = 0


    #[ItemModel, Category, SubCategory, Brand, ImageAttachment, Gender].each &:destroy_all
    begin
      key_index = 0 if key_list[key_index].blank?
      puts "using key=#{key_list[key_index]}"

      client = Zappos::Client.new(key_list[key_index], { :base_url => 'api.zappos.com' })
      response = client.search(:limit => 1)

      total_count = response.totalResultCount.to_i
      puts "found total #{total_count}"

      (total_count.to_f/search_opts[:limit].to_f).ceil.times do |index|
        begin
          key_index = 0 if key_list[key_index].blank?
          client = Zappos::Client.new(key_list[key_index], { :base_url => 'api.zappos.com' })
          response = client.search( search_opts.merge!({ :page => index + start_from_page.to_i }) )

          items = response.results
          puts "found #{items.size}. Running loop. page=#{index+start_from_page.to_i}"

          items.each do |item|
            begin
              puts "started item #{item.productId}"
              if ItemModel.find_by_external_product_id(item.productId)
                # puts "item ##{item.productId} exists in db. Skipping"
                next
              end

              ActiveRecord::Base.transaction do
                # puts "started transaction"

                product = client.product( product_search_opts.merge!({:id => item.productId}) ).data.product.first
                # puts "fetched product"

                brand = Brand.find_by_external_brand_id(product.brandId)
                # puts "fetched brand"

                image_feed = client.image( image_search_opts.merge!({:productId => item.productId})).data.images
                # puts "fetched image"

                unless brand
                  puts "creating brand: #{item.brandName} with id #{product.brandId}"
                  brand_feed = client.brand(brand_search_opts.merge!({:id => product.brandId})).try(:data).try(:brands).try(:first)
                  brand = Brand.create(
                    :name => item.brandName,
                    :description => brand_feed.try(:aboutText),
                    :external_brand_id => product.brandId,
                    :logo_url => brand_feed.try(:headerImageUrl)
                  )

                  begin
                    brand.image_attachments.create(:image_url => brand_feed.imageUrl)
                  rescue => image_error
                    brand.image_attachments.create
                    puts "error in creating image for brand. #{image_error.inspect}"
                  end
                end

                styles = product.styles
                description = Nokogiri::XML(product.description)
                description.search("ul li a").each(&:remove)
                item_model = ItemModel.create(
                  :external_product_id => item.productId,
                  :product_name => item.productName,
                  :brand => brand,
                  :category => Category.find_or_create_by_name(product.defaultCategory),
                  :sub_category => SubCategory.find_or_create_by_name(product.defaultSubCategory),
                  :gender => Gender.find_or_create_by_name(product.gender),
                  :description => description.root.to_s,
                  :weight => product.weight,
                  :video_url => product.videoUrl
                )
                # puts "item model created in db"

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
                    :on_sale => style_feed.onSale == "true",
                    :external_color_id => style_feed.colorId
                  )

                  image_feed[style_feed.styleId].each do |image|
                    style.image_attachments.create(
                      :image_url => image.filename,
                      :external_image_type => image.type,
                      :is_zoomed => image.recipeName == "4x"
                    )
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
                  puts "created #{style_feed.stocks.size} stocks"
                end
                puts "created #{styles.size} styles"
                puts "#{item_model.product_name} loaded. Id ##{item_model.id}"
              end
            rescue => error
              puts "Error in inner loop"
              p error.inspect
              key_index += 1
            end
          end
        rescue => error
          puts "Error in loop"
          p error.inspect
          key_index += 1
        end
      end
    rescue => error
      p error
      puts "Error in overall. Key rejected. Changing"
      key_index += 1
      retry
    end

  end

  desc "updates item model prices"
  task :update_prices => :environment do
    key_index = 0
    Style.all.each_with_index do |style, index|
      sleep 5 if index % 50 == 0
      begin
        if style.update_6pm_prices(style.product.item_model)
          style.update_attribute(:hidden, false) and next
        end
      rescue
      end
      begin
        if style.update_zappos_prices(style.product.item_model, key_index)
          style.update_attribute(:hidden, false)
        else
          style.update_attribute(:hidden, true)
        end
      rescue
        key_index += 1 and next
      end
    end
    Style.where(:hidden => true).each do |style|
      item_model = style.product.item_model
      style.destroy
      unless item_model.product.styles.any?
        item_model.destroy
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
    # TOP_CATEGORIES = { :clothes => 1, :shoes => 2, :accessories => 3, :watches => 4, :sunglasses => 5 }
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

  desc "loads facets"
  task :load_facets => :environment do
    key_index = 0
    ItemModel.where(:facet_loaded => false).order(:external_product_id).each do |item_model|
      begin
        key_index = 0 if key_list[key_index].blank?
        client = Zappos::Client.new(key_list[key_index], { :base_url => 'api.zappos.com' })
        facets = client.product( facet_search_opts.merge!({:id => item_model.external_product_id}) ).data.product.first.attributeFacetFields
        ActiveRecord::Base.transaction do
          facets.each do |facet_key, facet_value|
            begin
              item_model.update_attribute(facet_key, facet_value)
            rescue => error
              File.open('missing_facets.txt', 'a+'){|f| f.puts error}
            end
          end
          item_model.update_attribute(:facet_loaded, true)
        end
        puts "Item Model id:#{item_model.external_product_id} updated"
      rescue
        key_index += 1
      end
    end
  end

end

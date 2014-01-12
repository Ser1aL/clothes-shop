require 'open-uri'
require 'cgi'

namespace :data_feed do

  #zappos_key_list = %w(
  #  8bffaa3d5e1ccb6857544756293cf624f7d371d7
  #  3ae517aa832c98fc1d47c6d9d4669f05a5bda4cb
  #  1c256e0d9206018da4c6b574f4a7727369a821e6
  #  9a3e643501faa5feecc03ea9d1ec1fdf9217dcf1
  #  2d2df9b711b7950424b08be13736befc36071c1
  #  103a337b8da9bf07a2fbeaf1174863355578db20
  #  bd681f5813fecc01125f4b170139e7dbb5f57650
  #  806db79102d01b43100880d34187d5ebd79dda6c
  #  5f60e9616ce4dc1def1be1a9d4e5edb052bc5e2d
  #  611c3a7ab7dd6cc24c8eecf3d914a21511e549e3
  #  4fd6ec8ee757905d08c6b0e063ee53a3277d9903
  #  b9b79a15b2c0efeaa17e18d5d9ff1c0ba7f0fceb
  #  682e77c7447636780d5679a9bf6aa95c512e906c
  #  73d48a44f5aa34630603867d6f713214757581f
  #  36145a18b8611ac955474b3cace251fc724d779b
  #  9fb8ecbdd912c0207da2bac17de16eb631db70ae
  #)

  six_pm_key_list = %w(
    94342811fde7123e23978f827a654f5856cabcad
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
    :recipe => %w(MULTIVIEW 4x SWATCH),
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

    request_counter = 0
    #[ItemModel, Category, SubCategory, Brand, ImageAttachment, Gender].each &:destroy_all
    begin
      break if request_counter >= 1200
      key_index = 0 if six_pm_key_list[key_index].blank?
      puts "using key=#{six_pm_key_list[key_index]}"

      client = Zappos::Client.new(six_pm_key_list[key_index], { :base_url => 'api.6pm.com' })
      # 6pm req #1.1
      response = client.search(:limit => 1)
      request_counter += 1
      total_count = response.totalResultCount.to_i
      puts "found total #{total_count}"

      (total_count.to_f/search_opts[:limit].to_f).ceil.times do |index|
        next if request_counter >= 1200
        begin
          key_index = 0 if six_pm_key_list[key_index].blank?
          client = Zappos::Client.new(six_pm_key_list[key_index], { :base_url => 'api.6pm.com' })

          # 6pm req #2.1
          response = client.search( search_opts.merge!({ :page => index + start_from_page.to_i }) )
          request_counter += 1
          items = response.results
          puts "found #{items.size}. Running loop. page=#{index+start_from_page.to_i}"

          items.each do |item|
            begin
              puts "started item #{item.productId}"

              # reload item if not 6pm
              # if found item is zappos or else, remove it as we prioritize 6pm products
              existing_item = ItemModel.find_by_external_product_id(item.productId)
              if existing_item
                if existing_item.origin == '6pm'
                  next
                else
                  existing_item.destroy
                end
              end

              ActiveRecord::Base.transaction do
                # puts "started transaction"

                # 6pm req #3.1
                product = client.product( product_search_opts.merge!({:id => item.productId}) ).data.product.first
                request_counter += 1
                # puts "fetched product"

                brand = Brand.find_by_external_brand_id(product.brandId)
                # puts "fetched brand"

                # 6pm req #3.2
                image_feed = client.image( image_search_opts.merge!({:productId => item.productId})).data.images
                request_counter += 1

                # puts "fetched image"

                unless brand
                  puts "creating brand: #{item.brandName} with id #{product.brandId}"

                  # 6pm req #3.3
                  brand_feed = client.brand(brand_search_opts.merge!({:id => product.brandId})).try(:data).try(:brands).try(:first)
                  request_counter += 1
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
                  :video_url => product.videoUrl,
                  :origin => '6pm'
                )
                # puts "item model created in db"

                product_model = Product.create(
                  :item_model => item_model,
                  :total_quantity => 0
                )
                #puts "styles = #{styles.inspect}"
                styles.each do |style_feed|
                  # Zappos from time to time provides products with 1-3$ price. Skip them
                  next if style_feed.price[1..-1].to_f <= 3

                  swatch_url = image_feed[style_feed.styleId].select{ |image| image.recipeName == "SWATCH" }.first.try(:filename)

                  style = Style.create(
                    :color => style_feed.color,
                    :original_price => style_feed.originalPrice[1..-1].to_f,
                    :discount_price => style_feed.price[1..-1].to_f,
                    :product => product_model,
                    :percent_off => style_feed.percentOff.to_i,
                    :external_style_id => style_feed.styleId,
                    :on_sale => style_feed.onSale == "true",
                    :external_color_id => style_feed.colorId,
                    :swatch_url => swatch_url
                  )

                  image_feed[style_feed.styleId].each do |image|
                    next if image.recipeName == "SWATCH"
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

  desc 'update styles'
  task :update_styles => :environment do
    output_file = File.open("log/update_styles.txt", "a+")
    sixpm_request_counter, zappos_request_counter = 0, 0
    4000.times do |cycle|
      hidden_styles_count = 0
      output_file.puts "[#{Time.now.to_s(:db)} - Cycle start] Updating #{cycle*100}-#{(cycle+1)*100} styles"
      Style.where(:hidden => false).order("original_price ASC").limit(100).offset(100*cycle).each_with_index do |style, index|
        sleep 5 if index % 10 == 0
        if sixpm_request_counter < 800
          begin
            output_file.puts "[#{Time.now.to_s(:db)} - ##{index}] Requesting 6pm. Item Model: ##{style.product.item_model.external_product_id}, Color id: ##{style.external_color_id}"
            if style.update_6pm_prices(style.product.item_model)
              style.update_attribute(:hidden, false) and next
            end
            sixpm_request_counter += 1
          rescue => e
            output_file.puts "[#{Time.now.to_s(:db)} - ##{index}] Exception updating HTML 6pm: #{e.message}"
          end
        end

        if zappos_request_counter < 800
          begin
            output_file.puts "[#{Time.now.to_s(:db)} - ##{index}] Requesting zappos. Item Model: ##{style.product.item_model.external_product_id}, Color id: ##{style.external_color_id}"
            if style.update_zappos_prices(style.product.item_model)
              style.update_attribute(:hidden, false)
            else
              hidden_styles_count += 1
              style.update_attribute(:hidden, true)
            end
            zappos_request_counter += 1
          rescue => e
            output_file.puts "[#{Time.now.to_s(:db)} - ##{index}] Exception updating API zappos: #{e.message}"
          end
        end

      end
      output_file.puts "[#{Time.now.to_s(:db)} - Cycle done] Styles made hidden this cycle: #{hidden_styles_count}"
    end
  end

  desc '6pm grabber for first styles. Collect data to be removed'
  task :detect_styles_raw => :environment do
    output_file = File.open('log/6pm_raw_state_updates.csv', 'w')
    output_file.puts 'SKU|6pm page|Remove?'
    100.times do |cycle|
      Style.where(:hidden => false).order('original_price ASC').limit(100).offset(100*cycle).each_with_index do |style, _|
        begin
          page_url = "http://6pm.com/product/#{style.product.item_model.external_product_id}/color/#{style.external_color_id}"
          sku = style.product.item_model.external_product_id
          to_be_removed = style.raw_6pm_update ? 'No' : 'Yes'

          output_file.puts [sku, page_url, to_be_removed].join('|')
        rescue => e
          Rails.logger.debug "Got exception: #{e.inspect}"
        end
      end
    end
  end

  desc '6pm grabber for first styles. Collects data and removes'
  task :update_styles_raw => :environment do
    100.times do |cycle|
      Style.where(:hidden => false).order('original_price ASC').limit(100).offset(100*cycle).each_with_index do |style, _|
        begin
          style.raw_6pm_update(true)
        rescue => e
          Rails.logger.debug "Got exception: #{e.inspect}"
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
    top_level_categories = Category::TOP_CATEGORIES
    category_mapping.each do |category_name, page_name_6pm|
      Banner.where(:category_id => top_level_categories[category_name]).destroy_all

      nokogiri_page = Nokogiri::HTML(open("#{root_page}/#{page_name_6pm}"))
      nokogiri_page.css(".baffinGallery a img").map{|element| element.attributes["src"].to_s}.each do |image_link|
        Banner.create(:category_id => top_level_categories[category_name], :image_url => "#{root_page}#{image_link}")
      end

      # for index page load 2 more banners
      #if page_name_6pm.blank?
      begin
        first_banner = nokogiri_page.css(".imageFarm")[0].css("a img")[0].attribute("src").value
        second_banner = nokogiri_page.css(".imageFarm")[0].css("a img")[2].attribute("src").value
        Banner.create(:category_id => top_level_categories[category_name], :image_url => "#{root_page}#{first_banner}", :side => "left")
        Banner.create(:category_id => top_level_categories[category_name], :image_url => "#{root_page}#{second_banner}", :side => "right")
      rescue
        next
      end
      #end
    end

  end

  #desc "loads facets"
  #task :load_facets => :environment do
    #key_index = 0
    #ItemModel.where(:facet_loaded => false).order(:external_product_id).each do |item_model|
    #  begin
    #    key_index = 0 if zappos_key_list[key_index].blank?
    #    client = Zappos::Client.new(zappos_key_list[key_index], { :base_url => 'api.zappos.com' })
    #    facets = client.product( facet_search_opts.merge!({:id => item_model.external_product_id}) ).data.product.first.attributeFacetFields
    #    ActiveRecord::Base.transaction do
    #      facets.each do |facet_key, facet_value|
    #        begin
    #          item_model.update_attribute(facet_key, facet_value)
    #        rescue => error
    #          File.open('missing_facets.txt', 'a+'){|f| f.puts error}
    #        end
    #      end
    #      item_model.update_attribute(:facet_loaded, true)
    #    end
    #    puts "Item Model id:#{item_model.external_product_id} updated"
    #  rescue
    #    key_index += 1
    #  end
    #end
  #end

  #desc "load swatch images for existing styles"
  #task :load_swatches => :environment do
    #styles = Style.where(:swatch_url => nil, :hidden => false).order("id desc")
    #key_index = 0
    #image_search_opts = { :recipe => "SWATCH" }
    #styles.each_with_index do |style, index|
    #  puts index
    #  next if style.swatch_url.present?
    #  begin
    #    key_index = 0 if zappos_key_list[key_index].blank?
    #    client = Zappos::Client.new(zappos_key_list[key_index], { :base_url => 'api.zappos.com' })
    #    image_feed = client.image( image_search_opts.merge!({ :productId => style.product.item_model.external_product_id, :styleId => style.external_style_id }))
    #    puts "im: #{style.product.item_model.external_product_id}, style: #{style.external_style_id}, resp: #{image_feed.response}"
    #    image_feed = image_feed.data
    #    style.update_attribute(:swatch_url, image_feed[style.external_style_id].first.filename)
    #    sleep 0.3
    #  rescue => e
    #    key_index += 1
    #    puts "error in request: #{e.inspect}"
    #    next
    #  end
    #end
  #end
end

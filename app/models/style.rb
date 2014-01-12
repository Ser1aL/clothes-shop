require "open-uri"

class Style < ActiveRecord::Base
  belongs_to :product
  has_many :image_attachments, :as => :association, dependent: :destroy
  has_many :stocks, dependent: :destroy
  has_many :shopping_cart_lines, dependent: :destroy
  has_many :order_lines, dependent: :destroy

  # old key list
  #KEY_LIST = %w(
  #  682e77c7447636780d5679a9bf6aa95c512e906c
  #  36145a18b8611ac955474b3cace251fc724d779b
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
  #  73d48a44f5aa34630603867d6f713214757581f
  #  36145a18b8611ac955474b3cace251fc724d779b
  #  9fb8ecbdd912c0207da2bac17de16eb631db70ae
  #)

  KEY_LIST = %w(
    9a3e643501faa5feecc03ea9d1ec1fdf9217dcf1
  )

  SIXPM_KEY_LIST = %w(
    94342811fde7123e23978f827a654f5856cabcad
  )


  def original_price_extra(exchange_rate, markup, fixed_markup)
    ((original_price + original_price * markup / 100) * exchange_rate + fixed_markup.to_i).to_i
  end

  def discount_price_extra(exchange_rate, markup, fixed_markup)
    ((discount_price + discount_price * markup / 100) * exchange_rate + fixed_markup.to_i).to_i
  end

  def is_shoes?
    return false if stocks.blank?
    stocks[0].width.to_i.to_s != stocks[0].width && stocks[0].width != 'One Size'
  end

  def not_zoomed_image_attachments
    image_attachments.delete_if{ |image_attachment| image_attachment.is_zoomed }
  end

  def update_6pm_prices(item_model)
    product_search_opts = {
        :includes => %w(styles sortedSizes styles stocks onSale),
        :excludes => %w(productId brandName productName defaultImageUrl defaultProductUrl )
    }
    key = SIXPM_KEY_LIST.sample
    client = Zappos::Client.new(key, { :base_url => 'api.6pm.com' })
    response = client.product( product_search_opts.merge!({:id => item_model.external_product_id}) )

    Rails.logger.debug "===#{Time.now.utc} 6PM RESPONSE: #{response.inspect} #{response.response.instance_variable_get(:@header).inspect}============="

    raise if response.data.statusCode.to_i == 401
    product = response.data.product
    return false unless product
    styles = product.first.styles
    updated_styles_count = 0
    styles.each do |feed_style|
      next unless feed_style.styleId == external_style_id
      updated_styles_count += 1
      update_attributes(
          :original_price => feed_style.originalPrice[1..-1].to_f,
          :discount_price => feed_style.price[1..-1].to_f,
          :percent_off => feed_style.percentOff.to_i,
          :on_sale => feed_style.onSale == "true"
      )
      stocks.destroy_all
      feed_style.stocks.each do |feed_stock|
        self.stocks.create(
            :size => feed_stock['size'],
            :quantity => feed_stock.onHand,
            :width => feed_stock.width,
            :external_stock_id => feed_stock.stockId
        )
      end
    end
    updated_styles_count > 0 ? true : false
  end

  def update_zappos_prices(item_model, key_index = 0)
    product_search_opts = {
      :includes => %w(styles sortedSizes styles stocks onSale),
      :excludes => %w(productId brandName productName defaultImageUrl defaultProductUrl )
    }
    key = KEY_LIST[key_index] || KEY_LIST.sample
    client = Zappos::Client.new(key, { :base_url => 'api.zappos.com' })
    response = client.product( product_search_opts.merge!({:id => item_model.external_product_id}) )

    Rails.logger.debug "===#{Time.now.utc} ZAPPOS RESPONSE: #{response.inspect} #{response.response.instance_variable_get(:@header).inspect}============="

    raise if response.data.statusCode.to_i == 401
    product = response.data.product
    return false unless product
    styles = product.first.styles
    updated_styles_count = 0
    styles.each do |feed_style|
      next unless feed_style.styleId == external_style_id
      updated_styles_count += 1
      update_attributes(
        :original_price => feed_style.originalPrice[1..-1].to_f,
        :discount_price => feed_style.price[1..-1].to_f,
        :percent_off => feed_style.percentOff.to_i,
        :on_sale => feed_style.onSale == "true"
      )
      stocks.destroy_all
      feed_style.stocks.each do |feed_stock|
        self.stocks.create(
          :size => feed_stock['size'],
          :quantity => feed_stock.onHand,
          :width => feed_stock.width,
          :external_stock_id => feed_stock.stockId
        )
      end
    end
    updated_styles_count > 0 ? true : false
  end

  def raw_6pm_update(do_updates = false)
    path_to_product = "http://6pm.com/product/#{self.product.item_model.external_product_id}/color/#{external_color_id}"
    Rails.logger.debug "---------------------------------------------"
    Rails.logger.debug("updating info from 6pm url: #{path_to_product}")

    begin
      html = Nokogiri::HTML(open(path_to_product))
    rescue OpenURI::HTTPError => error
      Rails.logger.debug "openuri error: #{error.message}"
      return false if error.message == '404 Not Found'
    end

    Rails.logger.debug "HTML PAGE FETCHED"


    # ensure we are on this page
    return false unless html.css("#detailImage").to_s =~ /#{external_style_id}/

    html.css("ul li#priceSlot .oldPrice").text =~ %r(\$([\d\.]*))
    original_price = $1
    if original_price.blank?
      html.css(".discount").text =~ %r(\$([\d\.]*))
      original_price = $1
    end
    html.css("ul li#priceSlot .price").text =~ %r(\$([\d\.]*))
    price = $1
    if price.blank?
      html.css("#price").text =~ %r(\$([\d\.]*))
      price = $1
    end
    # recreating stocks
    feed_stocks = html.css("select[name=dimensionValues] option")

    return false if price.blank? || original_price.blank? || feed_stocks.size <= 0

    percent_off = (1 - price.to_f / original_price.to_f).round(2) * 100

    Rails.logger.debug "percent_off = #{percent_off}"
    Rails.logger.debug "price = #{price}"
    Rails.logger.debug "original_price = #{original_price}"
    Rails.logger.debug "feed_stocks = #{feed_stocks}"

    if do_updates
      stocks.destroy_all
      feed_stocks[1..feed_stocks.size].each{ |stock| self.stocks.create(:size => stock.text, :quantity => 1) }
      self.update_attributes(
          :original_price => original_price,
          :discount_price => price,
          :percent_off => percent_off
      )
    end
    Rails.logger.debug "---------------------------------------------"
    true
  end

  def primary_image
    not_zoomed_image_attachments.select{|i| i.image_url =~ /-p/ || i.image_url =~ /p-/ }.first || not_zoomed_image_attachments.first
  end

  def self.get_items(params = {}, exchange_rate = 1, markup = 1)
    [:brand, :gender, :sub_category, :category, :top_level_cat_id].each do |param|
      params[param] = $1 if params[param] =~ /(\d*)-(.*)/
    end

    conditions = ["styles.hidden = 0"]
    conditions << "brand_id = '#{params[:brand]}'" if params[:brand]
    conditions << "gender_id = '#{params[:gender]}'" if params[:gender]
    conditions << "sub_category_id = '#{params[:sub_category]}'" if params[:sub_category]
    conditions << "category_id = '#{params[:category]}'" if params[:category]
    conditions << "categories.top_category = '#{params[:top_level_cat_id]}'" if params[:top_level_cat_id]
    if params[:price_range].present?
      min_price, max_price = params[:price_range].split("-")
      min_price = (min_price.to_i - min_price.to_i * markup / 100 ) / exchange_rate
      max_price = (max_price.to_i - max_price.to_i * markup / 100 ) / exchange_rate
      conditions << "styles.discount_price > #{min_price.to_i}"
      conditions << "styles.discount_price < #{max_price.to_i}"
    end

    joins(:product => [:item_model => :category]).group('styles.id').where(conditions.join(' AND ')).order(:discount_price).page(params[:page]).per(10)
  end

  def self.get_items_extended(params, exchange_rate, markup)
    [:brand, :gender, :sub_category, :category, :top_level_cat_id].each do |param|
      params[param] = $1 if params[param] =~ /(\d*)-(.*)/
    end

    conditions = ["styles.hidden = 0"]
    conditions << "item_models.brand_id = '#{params[:brand]}'" if params[:brand]
    conditions << "item_models.gender_id = '#{params[:gender]}'" if params[:gender]
    conditions << "item_models.sub_category_id = '#{params[:sub_category]}'" if params[:sub_category]
    conditions << "item_models.category_id = '#{params[:category]}'" if params[:category]
    conditions << "styles.color = '#{params[:color]}'" if params[:color]
    conditions << "stocks.size = '#{params[:size].gsub(/\\/, '\&\&').gsub(/'/, "''")}'" if params[:size]
    conditions << "categories.top_category = '#{params[:top_level_cat_id]}'" if params[:top_level_cat_id]
    if params[:price_range].present?
      min_price, max_price = params[:price_range].split("-")
      min_price = (min_price.to_i - min_price.to_i * markup / 100 ) / exchange_rate
      max_price = (max_price.to_i - max_price.to_i * markup / 100 ) / exchange_rate
      conditions << "styles.discount_price > #{min_price}"
      conditions << "styles.discount_price < #{max_price}"
    end
    relation = joins(:stocks).joins(:product => [:item_model => [:brand, :gender, :category]]).joins('LEFT JOIN `sub_categories` ON `sub_categories`.`id` = `item_models`.`sub_category_id` ')
    relation = relation.order(:discount_price).group('styles.id')
    relation.where(conditions.join(' AND ')).page(params[:page]).per(10)
  end

  def to_param
    "#{id}-#{color.parameterize}"
  end
end

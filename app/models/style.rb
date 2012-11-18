require "open-uri"

class Style < ActiveRecord::Base
  belongs_to :product
  has_many :image_attachments, :as => :association
  has_many :stocks
  has_many :shopping_cart_lines
  has_many :order_lines

  KEY_LIST = %w(
    682e77c7447636780d5679a9bf6aa95c512e906c
    36145a18b8611ac955474b3cace251fc724d779b
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
    73d48a44f5aa34630603867d6f713214757581f
    36145a18b8611ac955474b3cace251fc724d779b
    9fb8ecbdd912c0207da2bac17de16eb631db70ae
  )


  def original_price_extra(exchange_rate, markup)
    ((original_price + original_price * markup / 100) * exchange_rate).to_i
  end

  def discount_price_extra(exchange_rate, markup)
    ((discount_price + discount_price * markup / 100) * exchange_rate).to_i
  end

  def is_shoes?
    stocks[0].width.to_i.to_s != stocks[0].width && stocks[0].width != 'One Size'
  end

  def not_zoomed_image_attachments
    image_attachments.delete_if{ |image_attachment| image_attachment.is_zoomed }
  end

  def update_6pm_prices(item_model)
    path_to_product = "http://6pm.com/product/#{item_model.external_product_id}/color/#{external_color_id}"
    Rails.logger.debug("updating info from 6pm url: #{path_to_product}")
    html = Nokogiri::HTML(open(path_to_product))

    # ensure we are on this page
    return unless html.css("#detailImage").to_s =~ /#{external_style_id}/

    html.css("ul li#percentOff").text.strip =~ %r((\d{2})\%)
    percent_off = $1
    if percent_off.blank?
      html.css("span.discount strong").text.strip =~ %r((\d{2})\%)
      percent_off = $1
    end
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

    return if percent_off.blank? || price.blank? || original_price.blank? || feed_stocks.size <= 0
    stocks.destroy_all
    feed_stocks[1..feed_stocks.size].each{ |stock| self.stocks.create(:size => stock.text, :quantity => 1) }
    self.update_attributes(
      :original_price => original_price,
      :discount_price => price,
      :percent_off => percent_off
    )
    true
  end

  def update_zappos_prices(item_model, key_index = 0)
    Rails.logger.debug("updating info from zappos api")
    product_search_opts = {
      :includes => %w(gender description weight videoUrl styles sortedSizes styles stocks onSale defaultCategory defaultSubCategory colorId),
      :excludes => %w(productId brandName productName defaultImageUrl defaultProductUrl )
    }
    key = KEY_LIST[key_index] || KEY_LIST.sample
    client = Zappos::Client.new(key, { :base_url => 'api.zappos.com' })
    response = client.product( product_search_opts.merge!({:id => item_model.external_product_id}) )
    raise if response.data.statusCode.to_i == 401
    product = response.data.product
    return false unless product
    styles = product.first.styles
    styles.each do |feed_style|
      next unless feed_style.styleId == external_style_id
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
    true
  end
end

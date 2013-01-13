
namespace :sitemap do

  desc 'builds sitemap.xml'
  task :build => :environment do
    include ActionDispatch::Routing::UrlFor
    include Rails.application.routes.url_helpers

    default_url_options[:host] = 'shop-mydostavka.com'
    sitemaps = []
    pages = [
      "http://shop-mydostavka.com/about_us",
      "http://shop-mydostavka.com/",
      "http://shop-mydostavka.com/advanced_search",
      "http://shop-mydostavka.com/reviews",
      "http://shop-mydostavka.com/payments",
      "http://shop-mydostavka.com/deliveries",
      "http://shop-mydostavka.com/contacts",
      "http://shop-mydostavka.com/brands",
    ]

    ("A".."Z").each{ |letter| pages.push("http://shop-mydostavka.com/brands?letter=#{letter}") }
    Brand.all.each{ |brand| pages.push(brand_url(brand)) }

    (1..6).each{ |category_id| pages.push("http://shop-mydostavka.com/categories/#{category_id}") }

    # first build non-product sitemap
    xml = Builder::XmlMarkup.new(:target => File.open(File.join(Rails.root, 'public/sitemap_non_product.xml'), 'w'), :indent => 1)
    xml.instruct!
    xml.urlset(:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9",
               "xmlns:xsi"=> "http://www.w3.org/2001/XMLSchema-instance",
               "xsi:schemaLocation"=>"http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd") do
      pages.each do |page|
        xml.url do
          xml.loc page
        end
      end
    end
    sitemaps << 'sitemap_non_product.xml'

    product_pages = []
    Style.includes(:product => :item_model).each_with_index do |style, index|
      next unless style.product
      next unless style.product.item_model
      product_pages << single_model_url(style.product.item_model, style)
    end

    # build product sitemaps with upper 40k threshold
    product_pages.each_slice(40000).with_index do |slice, index|
      xml = Builder::XmlMarkup.new(:target => File.open(File.join(Rails.root, "public/sitemap_products_#{index}.xml"), 'w'), :indent => 1)
      xml.instruct!
      xml.urlset(:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9",
                 "xmlns:xsi"=> "http://www.w3.org/2001/XMLSchema-instance",
                 "xsi:schemaLocation"=>"http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd") do
        slice.each do |page|
          xml.url do
            xml.loc page
          end
        end
      end
      sitemaps << "sitemap_products_#{index}.xml"
    end

    # build main sitemap
    xml = Builder::XmlMarkup.new(:target => File.open(File.join(Rails.root, 'public/sitemap.xml'), 'w'), :indent => 1)
    xml.instruct!
    xml.sitemapindex(:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9") do
      sitemaps.each do |sitemap|
        xml.sitemap do
          xml.loc "http://shop-mydostavka.com/#{sitemap}"
        end
      end
    end


  end
end
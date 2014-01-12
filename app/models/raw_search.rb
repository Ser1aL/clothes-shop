class RawSearch

  def self.get_counts(params, type, exchange_rate, markup)


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
      conditions << "styles.discount_price > #{min_price.to_i}"
      conditions << "styles.discount_price < #{max_price.to_i}"
    end


    conditions = conditions.blank? ? "1=1" : conditions.join(" AND ")

    search_query = <<-SQL
      SELECT #{type.to_s.pluralize}.id as #{type.to_s}_id,
        IFNULL(#{type.to_s.pluralize}.display_name,#{type.to_s.pluralize}.name) as type_name
      FROM item_models
        LEFT JOIN sub_categories ON sub_categories.id = item_models.sub_category_id
      INNER JOIN brands ON brands.id = item_models.brand_id
      INNER JOIN genders ON genders.id = item_models.gender_id
      INNER JOIN categories ON categories.id = item_models.category_id
      INNER JOIN products ON products.item_model_id = item_models.id
      INNER JOIN styles ON styles.product_id = products.id
      INNER JOIN stocks ON stocks.style_id = styles.id
      WHERE
        #{conditions}
      GROUP BY #{type.to_s.pluralize}.id
    SQL

    ActiveRecord::Base.connection.select_all(search_query).group_by{|r| r["#{type.to_s}_id"]}.map do |type_id, group|
      next if group.first["type_name"].blank?
      Hashie::Mash.new({
        :counting => group.size,
        :type_name => group.first["type_name"],
        "#{type.to_s}_id".to_sym => type_id
      }.merge!(params))
    end.compact.sort_by{|r| r[:type_name].first.capitalize + r[:type_name].try(:[], 1).try(:capitalize).to_s}
  end

  def self.get_size_counts(params, exchange_rate, markup)

    conditions = ["styles.hidden = 0"]
    conditions << "item_models.brand_id = '#{params[:brand]}'" if params[:brand]
    conditions << "item_models.gender_id = '#{params[:gender]}'" if params[:gender]
    conditions << "item_models.sub_category_id = '#{params[:sub_category]}'" if params[:sub_category]
    conditions << "item_models.category_id = '#{params[:category]}'" if params[:category]
    conditions << "styles.color = '#{params[:color]}'" if params[:color]
    conditions << "stocks.size = '#{params[:size].gsub(/\\/, '\&\&').gsub(/'/, "''")}'" if params[:size]
    if params[:price_range].present?
      min_price, max_price = params[:price_range].split("-")
      min_price = (min_price.to_i - min_price.to_i * markup / 100 ) / exchange_rate
      max_price = (max_price.to_i - max_price.to_i * markup / 100 ) / exchange_rate
      conditions << "styles.discount_price > #{min_price.to_i}"
      conditions << "styles.discount_price < #{max_price.to_i}"
    end

    conditions = conditions.blank? ? "1=1" : conditions.join(" AND ")

    search_query = <<-SQL
      SELECT stocks.size
      FROM stocks
      INNER JOIN styles ON stocks.style_id = styles.id
      INNER JOIN products ON styles.product_id = products.id
      INNER JOIN item_models ON products.item_model_id = item_models.id
      WHERE
        #{conditions}
      LIMIT 200
    SQL

    ActiveRecord::Base.connection.select_all(search_query).group_by{|r| r['size']}.map do |size, group|
      Hashie::Mash.new({
        :count => 0,
        :type_name => size,
        :size_value => size
      }.merge!(params))
    end.sort_by{|r| r[:type_name].first.capitalize}[0..29]
  end

  def self.get_color_counts(params, exchange_rate, markup)

    conditions = ["styles.hidden = 0"]
    conditions << "item_models.brand_id = '#{params[:brand]}'" if params[:brand]
    conditions << "item_models.gender_id = '#{params[:gender]}'" if params[:gender]
    conditions << "item_models.sub_category_id = '#{params[:sub_category]}'" if params[:sub_category]
    conditions << "item_models.category_id = '#{params[:category]}'" if params[:category]
    conditions << "styles.color = '#{params[:color]}'" if params[:color]
    conditions << "stocks.size = '#{params[:size].gsub(/\\/, '\&\&').gsub(/'/, "''")}'" if params[:size]

    if params[:price_range].present?
      min_price, max_price = params[:price_range].split("-")
      min_price = (min_price.to_i - min_price.to_i * markup / 100 ) / exchange_rate
      max_price = (max_price.to_i - max_price.to_i * markup / 100 ) / exchange_rate
      conditions << "styles.discount_price > #{min_price.to_i}"
      conditions << "styles.discount_price < #{max_price.to_i}"
    end

    conditions = conditions.blank? ? "" : "AND " + conditions.join(" AND ")

    # pick first 200, but return only 21 unique
    search_query = <<-SQL
      SELECT styles.color, styles.swatch_url
      FROM item_models
      INNER JOIN products ON products.item_model_id = item_models.id
      INNER JOIN styles ON styles.product_id = products.id
      INNER JOIN stocks ON stocks.style_id = styles.id
      WHERE
        styles.swatch_url IS NOT NULL
        #{conditions}
      GROUP BY item_models.id
      LIMIT 200
    SQL

    ActiveRecord::Base.connection.select_all(search_query).group_by{|r| r["color"]}.map do |color, group|
      Hashie::Mash.new({
        :type_name => color,
        :swatch_url => group.first['swatch_url'],
        :color => color
      }).merge!(params)
    end.sort_by{|r| r[:type_name].first.capitalize}[0..20]
  end

end

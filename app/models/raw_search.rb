class RawSearch

  def self.get_counts(params, type)

    conditions = []
    conditions << "item_models.brand_id = '#{params[:brand_id]}'" if params[:brand_id]
    conditions << "item_models.gender_id = '#{params[:gender_id]}'" if params[:gender_id]
    conditions << "item_models.sub_category_id = '#{params[:sub_category_id]}'" if params[:sub_category_id]
    conditions << "item_models.category_id = '#{params[:category_id]}'" if params[:category_id]
    conditions << "styles.color = '#{params[:color]}'" if params[:color]
    conditions << "stocks.size = '#{params[:size].gsub(/\\/, '\&\&').gsub(/'/, "''")}'" if params[:size]

    conditions = conditions.blank? ? "" : "AND " + conditions.join(" AND ")

    search_query = <<-SQL
      SELECT #{type.to_s.pluralize}.id as #{type.to_s}_id,
        IFNULL(#{type.to_s.pluralize}.display_name,#{type.to_s.pluralize}.name) as type_name
      FROM item_models, brands, genders, sub_categories, products, styles, stocks, categories
      WHERE brands.id = item_models.brand_id
        AND genders.id = item_models.gender_id
        AND sub_categories.id = item_models.sub_category_id
        AND categories.id = item_models.category_id
        AND products.item_model_id = item_models.id
        AND styles.product_id = products.id
        AND stocks.style_id = styles.id
      #{conditions}
      GROUP BY item_models.id, #{type.to_s.pluralize}.id
    SQL

    ActiveRecord::Base.connection.select_all(search_query).group_by{|r| r["#{type.to_s}_id"]}.map{|type_id, group|
      {
        :count => group.size,
        :type_name => group.first["type_name"],
        "#{type.to_s}_id".to_sym => type_id
      }.merge!(params)
    }.sort_by{|r| r[:type_name].first.capitalize + r[:type_name].try(:[], 1).try(:capitalize).to_s}
  end

  def self.get_size_counts(params)

    conditions = []
    conditions << "item_models.brand_id = '#{params[:brand_id]}'" if params[:brand_id]
    conditions << "item_models.gender_id = '#{params[:gender_id]}'" if params[:gender_id]
    conditions << "item_models.sub_category_id = '#{params[:sub_category_id]}'" if params[:sub_category_id]
    conditions << "item_models.category_id = '#{params[:category_id]}'" if params[:category_id]
    conditions << "styles.color = '#{params[:color]}'" if params[:color]
    conditions << "stocks.size = '#{params[:size].gsub(/\\/, '\&\&').gsub(/'/, "''")}'" if params[:size]

    conditions = conditions.blank? ? "" : "AND " + conditions.join(" AND ")

    search_query = <<-SQL
      SELECT stocks.size
      FROM item_models, products, styles, stocks
      WHERE products.item_model_id = item_models.id
        AND styles.product_id = products.id
        AND stocks.style_id = styles.id
        #{conditions}
      GROUP BY stocks.size
    SQL

    ActiveRecord::Base.connection.select_all(search_query).map{|size|
      {
        :count => 0,
        :type_name => size["size"],
        :size => size["size"]
      }.merge!(params)
    }.sort_by{|r| r[:type_name].first.capitalize}
  end

  def self.get_color_counts(params)

    conditions = []
    conditions << "item_models.brand_id = '#{params[:brand_id]}'" if params[:brand_id]
    conditions << "item_models.gender_id = '#{params[:gender_id]}'" if params[:gender_id]
    conditions << "item_models.sub_category_id = '#{params[:sub_category_id]}'" if params[:sub_category_id]
    conditions << "item_models.category_id = '#{params[:category_id]}'" if params[:category_id]
    conditions << "styles.color = '#{params[:color]}'" if params[:color]
    conditions << "stocks.size = '#{params[:size].gsub(/\\/, '\&\&').gsub(/'/, "''")}'" if params[:size]

    conditions = conditions.blank? ? "" : "AND " + conditions.join(" AND ")

    search_query = <<-SQL
      SELECT count(item_models.id) as count, styles.color
      FROM item_models, products, styles, stocks
      WHERE products.item_model_id = item_models.id
        AND styles.product_id = products.id
        AND stocks.style_id = styles.id
        #{conditions}
      GROUP BY item_models.id, styles.color
    SQL

    ActiveRecord::Base.connection.select_all(search_query).group_by{|r| r["color"]}.map{|color, group|
      {
        :count => group.size,
        :type_name => color,
        :color => color
      }.merge!(params)
    }.sort_by{|r| r[:type_name].first.capitalize}
  end

end
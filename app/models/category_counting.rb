class CategoryCounting < Counting

  belongs_to :brand
  belongs_to :category
  belongs_to :sub_category
  belongs_to :gender

  def self.grouped_by_category
    select("sum(value) as value, category_id, category_name, sub_category_name, sub_category_id").group(:category_id, :sub_category_id).order(:sub_category_name).group_by(&:category_id)
  end


  def self.counts_with_favorite(type, params = {})
    select = "#{type}_id, IFNULL(#{type}_name, category_name) as name, sum(value) as item_count"

    active_params = [:brand, :category, :sub_category, :gender].map{ |param| param if params[param].present? }.compact
    conditions = ''
    if active_params.present?
      conditions = 'WHERE ' + active_params.map{ |param| "#{param}_id = #{params[param]}" }.join(" AND ")
    end

    sql = "SELECT #{select} FROM countings #{conditions} GROUP BY #{type}_id"
    if type == :gender
      favorites = :all
    else
      favorites = type.to_s.camelcase.constantize.where(:favorite => true).map(&:id)
    end

    find_by_sql(sql).map do |db_record|
      attributes = db_record.attributes
      attributes["item_count"] = attributes["item_count"].to_i
      if type == :gender
        attributes
      else
        attributes if attributes["id"] && favorites.include?(attributes["id"])
      end
    end.compact
  end
end
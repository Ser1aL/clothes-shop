class ItemModel < ActiveRecord::Base
  has_one :product
  has_many :comments, :as => :association

  belongs_to :brand
  belongs_to :category
  belongs_to :sub_category
  belongs_to :color

  def self.latest(page)
    page(page).per(6)
  end

  def self.single(id)
    find(id)
  end

  def has_product?
    product && product.quantity > 0
  end

  def full_description
    [color.name, sub_category.name, category.name, color.name].delete_if{ |x| x.blank? }.join ', '
  end

  def self.counts_by_type type
    return [] if !['brand', 'category', 'color', 'sub_category'].include? type.to_s
    type = type.to_s
    find_by_sql("SELECT #{type.pluralize}.id, #{type.pluralize}.name, COUNT(item_models.id) as item_count
      FROM #{type.pluralize}, item_models
      WHERE #{type.pluralize}.id = item_models.#{type}_id
      GROUP BY #{type.pluralize}.id").map(&:attributes)
  end

  def self.detailed_counts_by_type type, brand_id
    sql_condition = ''
    sql_condition = " AND brands.id = '#{brand_id}'" if !brand_id.blank?
    type = "#{type.to_s}"
    find_by_sql("SELECT #{type.pluralize}.id, #{type.pluralize}.name, COUNT(item_models.id) as item_count
      FROM #{type.pluralize}, item_models, brands
      WHERE brands.id = item_models.brand_id
        AND #{type.pluralize}.id = item_models.#{type}_id
        #{sql_condition}
      GROUP BY #{type.pluralize}.id").map(&:attributes)
  end

  def self.get_items(*args)
    brand, color, sub_category, category, page = args[0][:brand], args[0][:color], args[0][:sub_category], args[0][:category], args[0][:page]
    conditions = []
    conditions << "brand_id = '#{brand}'" if brand
    conditions << "color_id = '#{color}'" if color
    conditions << "sub_category_id = '#{sub_category}'" if sub_category
    conditions << "category_id = '#{category}'" if category
    where(conditions.join(' AND ')).page(page).per(6)
  end

  # change to sphinx when 2.0+ is well tested
  def self.search query, page
    query = "%#{query.strip}%"
    joins(:color, :category, :brand, :sub_category).where('brands.name like ?', query).page(page).per(6)
  end

end

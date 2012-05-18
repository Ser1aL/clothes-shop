class ItemModel < ActiveRecord::Base
  has_one :product
  has_many :comments, :as => :association

  belongs_to :brand
  belongs_to :category
  belongs_to :sub_category
  belongs_to :gender

  PRICE_UPDATE_INTERVAL = 1.second


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
    [brand.name, sub_category.name, category.name, gender.name].delete_if{ |x| x.blank? }.join ', '
  end

  def self.counts_by_type type
    return [] if !['brand', 'category', 'gender', 'sub_category'].include? type.to_s
    type = type.to_s
    find_by_sql("SELECT #{type.pluralize}.id, #{type.pluralize}.name, COUNT(item_models.id) as item_count
      FROM #{type.pluralize}, item_models
      WHERE #{type.pluralize}.id = item_models.#{type}_id
      GROUP BY #{type.pluralize}.id
      ORDER BY item_count DESC").map(&:attributes)
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
    brand, gender, sub_category, category, page = args[0][:brand], args[0][:gender], args[0][:sub_category], args[0][:category], args[0][:page]
    conditions = []
    conditions << "brand_id = '#{brand}'" if brand
    conditions << "gender_id = '#{gender}'" if gender
    conditions << "sub_category_id = '#{sub_category}'" if sub_category
    conditions << "category_id = '#{category}'" if category
    where(conditions.join(' AND ')).page(page).per(6)
  end

  # change to sphinx when 2.0+ is well tested
  def self.search query, page
    query = "%#{query.strip}%"
    joins(:gender, :category, :brand, :sub_category).where('
      brands.name like ? OR
      categories.name LIKE ? OR
      genders.name LIKE ? OR
      sub_categories.name LIKE ? OR
      item_models.product_name LIKE ? OR
      item_models.description LIKE ?', query, query, query, query, query, query).page(page).per(6)
  end

  def self.with_price_not_updated
    ItemModel.joins( :product => :styles ).where("styles.updated_at < ?", Time.now - PRICE_UPDATE_INTERVAL)
  end

end

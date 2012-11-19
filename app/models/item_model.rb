class ItemModel < ActiveRecord::Base
  has_one :product
  has_many :comments, :as => :association

  belongs_to :brand
  belongs_to :category
  belongs_to :sub_category
  belongs_to :gender

  # default_scope :order => 'item_models.updated_at DESC'

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
    [brand.name, sub_category.try(:name).to_s, category.name, gender.name].delete_if{ |x| x.blank? }.join ', '
  end

  def self.counts_by_type(type)
    return [] if !['brand', 'category', 'gender', 'sub_category'].include? type.to_s
    type = type.to_s
    find_by_sql("SELECT #{type.pluralize}.id,
      IF(#{type.pluralize}.display_name IS NOT NULL,
          UPPER(#{type.pluralize}.display_name),
          #{type.pluralize}.name) as name,
        COUNT(item_models.id) as item_count
      FROM #{type.pluralize}, item_models
      WHERE #{type.pluralize}.id = item_models.#{type}_id
      GROUP BY #{type.pluralize}.id
      ORDER BY item_count DESC, name ASC
      LIMIT 10").map(&:attributes)
  end

  def self.get_items(params = {})
    conditions = []
    conditions << "brand_id = '#{params[:brand]}'" if params[:brand]
    conditions << "gender_id = '#{params[:gender]}'" if params[:gender]
    conditions << "sub_category_id = '#{params[:sub_category]}'" if params[:sub_category]
    conditions << "category_id = '#{params[:category]}'" if params[:category]
    where(conditions.join(' AND ')).order('item_models.updated_at DESC').page(params[:page]).per(6)
  end

  def self.get_items_extended(params = {})
    conditions = []
    conditions << "item_models.brand_id = '#{params[:brand_id]}'" if params[:brand_id]
    conditions << "item_models.gender_id = '#{params[:gender_id]}'" if params[:gender_id]
    conditions << "item_models.sub_category_id = '#{params[:sub_category_id]}'" if params[:sub_category_id]
    conditions << "item_models.category_id = '#{params[:category_id]}'" if params[:category_id]
    conditions << "styles.color = '#{params[:color]}'" if params[:color]
    conditions << "stocks.size = '#{params[:size].gsub(/\\/, '\&\&').gsub(/'/, "''")}'" if params[:size]
    includes(:brand, :gender, :sub_category, :product => [:styles => :stocks]).where(conditions.join(' AND '))

  end

  # change to sphinx when 2.0+ is well tested
  def self.search query, page
    query = "%#{query.to_s.strip}%"
    joins(:gender, :category, :brand, "LEFT JOIN `sub_categories` ON `sub_categories`.`id` = `item_models`.`sub_category_id` ").where('
      brands.name like ? OR
      categories.name LIKE ? OR
      sub_categories.name LIKE ? OR
      item_models.product_name LIKE ? OR
      item_models.external_product_id LIKE ?', query, query, query, query, query).page(page).per(6)
  end

  def self.with_price_not_updated
    ItemModel.joins( :product => :styles ).where("styles.updated_at < ?", Time.now - PRICE_UPDATE_INTERVAL)
  end

end

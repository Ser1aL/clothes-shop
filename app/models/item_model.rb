class ItemModel < ActiveRecord::Base
  has_one :product, :dependent => :destroy
  has_many :comments, :as => :association

  belongs_to :brand
  belongs_to :category
  belongs_to :sub_category
  belongs_to :gender

  # default_scope :order => 'item_models.updated_at DESC'

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

  def product_name
    super.gsub('&#8482;', ' TM ')
  end

  def self.counts_by_type(type)
    return [] unless %w(brand category gender sub_category).include?(type.to_s)
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

  def to_param
    "#{id}-#{product_name.parameterize}"
  end

  define_index do
    indexes :product_name
    indexes :external_product_id
    indexes brand.name, :as => :brand_name
    indexes [category.name, category.display_name], :as => :category_name
    indexes [sub_category.name, sub_category.display_name], :as => :sub_category_name
  end
end

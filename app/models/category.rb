class Category < ActiveRecord::Base
  has_many :item_models
  has_many :banners
  validates_presence_of :name

  def sub_categories
    item_models.map(&:sub_category).uniq.sort_by(&:name)
  end

  def self.favorite_with_counts
    find_by_sql("SELECT categories.id, UPPER(IFNULL(categories.display_name, categories.name)) as name, COUNT(item_models.id) as item_count
      FROM categories, item_models
      WHERE categories.id = item_models.category_id
        AND categories.favorite = 1
      GROUP BY categories.id
      ORDER BY name
    ").map(&:attributes)
  end

  def self.prepare_model_counts(type, conditions = '')
    find_by_sql("SELECT #{type.to_s.pluralize}.id, UPPER(IFNULL(#{type.to_s.pluralize}.display_name, #{type.to_s.pluralize}.name)) as name, COUNT(item_models.id) as item_count
      FROM categories, item_models
      WHERE categories.id = item_models.category_id
        AND categories.favorite = 1
      GROUP BY categories.id
      ORDER BY name
    ").map(&:attributes)
  end

  def name
    display_name.blank? ? super : display_name
  end

end

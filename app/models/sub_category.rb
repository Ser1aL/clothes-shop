class SubCategory < ActiveRecord::Base
  has_many :item_models
  belongs_to :category
  validates_presence_of :name

  def name
    display_name.blank? ? super : display_name
  end

  def self.favorite_with_counts
    find_by_sql("SELECT sub_categories.id, UPPER(IFNULL(sub_categories.display_name, sub_categories.name)) as name, COUNT(item_models.id) as item_count
      FROM sub_categories, item_models
      WHERE sub_categories.id = item_models.sub_category_id
        AND sub_categories.favorite = 1
      GROUP BY sub_categories.id
      ORDER BY name
    ").map(&:attributes)
  end

end

namespace :db_prepare do

  desc "prepares categories/subcategories counts"
  task :categorize => :environment do
    no_brand_sql = <<-SQL
      INSERT INTO countings (category_name, category_id, sub_category_name, sub_category_id, gender_id, value )
      SELECT IF(categories.display_name IS NOT NULL, categories.display_name, categories.name) as category_name,
        item_models.category_id,
        IF(sub_categories.display_name IS NOT NULL, sub_categories.display_name, sub_categories.name) as sub_category_name,
        item_models.sub_category_id, count(*), item_models.gender_id
      FROM item_models, categories, sub_categories
      WHERE item_models.category_id = categories.id
        AND item_models.sub_category_id = sub_categories.id
      GROUP BY item_models.category_id, item_models.sub_category_id
    SQL

    brand_sql = <<-SQL
      INSERT INTO countings (category_name, category_id, sub_category_name, sub_category_id, value, gender_id, brand_id )
      SELECT IF(categories.display_name IS NOT NULL, categories.display_name, categories.name) as category_name,
        item_models.category_id,
        IF(sub_categories.display_name IS NOT NULL, sub_categories.display_name, sub_categories.name) as sub_category_name,
        item_models.sub_category_id, count(item_models.id), item_models.gender_id, item_models.brand_id
      FROM item_models, brands, categories, sub_categories
      WHERE item_models.category_id = categories.id
              AND item_models.sub_category_id = sub_categories.id
      AND item_models.brand_id = brands.id
      GROUP BY item_models.brand_id, item_models.category_id, item_models.sub_category_id
    SQL

    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.execute("TRUNCATE countings")
    ActiveRecord::Base.connection.execute(no_brand_sql)
    ActiveRecord::Base.connection.execute(brand_sql)
  end

end


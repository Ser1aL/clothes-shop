namespace :db_prepare do

  desc "prepares categories/subcategories counts"
  task :categorize => :environment do
    category_counts_sql = <<-SQL
      INSERT INTO countings (category_name, category_id, sub_category_name, sub_category_id, value, type )
      SELECT IF(categories.display_name IS NOT NULL, categories.display_name, categories.name) as category_name,
        item_models.category_id,
        IF(sub_categories.display_name IS NOT NULL, sub_categories.display_name, sub_categories.name) as sub_category_name,
        item_models.sub_category_id, count(*), 'CategoryCounting'
      FROM item_models, categories, sub_categories
      WHERE item_models.category_id = categories.id
        AND item_models.sub_category_id = sub_categories.id
      GROUP BY item_models.category_id, item_models.sub_category_id
    SQL

    brand_counts_sql = <<-SQL
      INSERT INTO countings (category_name, category_id, sub_category_name, sub_category_id, value, brand_id, type )
      SELECT IF(categories.display_name IS NOT NULL, categories.display_name, categories.name) as category_name,
        item_models.category_id,
        IF(sub_categories.display_name IS NOT NULL, sub_categories.display_name, sub_categories.name) as sub_category_name,
        item_models.sub_category_id, count(item_models.id), item_models.brand_id, 'BrandCounting'
      FROM item_models, brands, categories, sub_categories
      WHERE item_models.category_id = categories.id
              AND item_models.sub_category_id = sub_categories.id
      AND item_models.brand_id = brands.id
      GROUP BY item_models.brand_id, item_models.category_id, item_models.sub_category_id
    SQL

    gender_counts_sql = <<-SQL
      INSERT INTO countings (gender_name, value, gender_id, type )
      SELECT
        IF(genders.display_name IS NOT NULL, genders.display_name, genders.name) as gender_name,
        count(item_models.id), item_models.gender_id, 'GenderCounting'
      FROM item_models, genders
      WHERE item_models.gender_id = genders.id
      GROUP BY item_models.gender_id
    SQL

    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.execute("TRUNCATE countings")
    ActiveRecord::Base.connection.execute(category_counts_sql)
    ActiveRecord::Base.connection.execute(brand_counts_sql)
    ActiveRecord::Base.connection.execute(gender_counts_sql)
  end

end


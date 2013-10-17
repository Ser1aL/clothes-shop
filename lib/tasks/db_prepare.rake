namespace :db_prepare do

  desc "prepares categories/subcategories counts"
  task :categorize => :environment do
    category_counts_sql = <<-SQL
      INSERT INTO countings (category_name, category_id, sub_category_name, sub_category_id, value, gender_id, brand_id, gender_name, brand_name )
      SELECT IF(categories.display_name IS NOT NULL, categories.display_name, categories.name) as category_name,
        item_models.category_id,
        IF(sub_categories.display_name IS NOT NULL, sub_categories.display_name, sub_categories.name) as sub_category_name,
        item_models.sub_category_id, count(item_models.id), item_models.gender_id, item_models.brand_id,
        IF(genders.display_name IS NOT NULL, genders.display_name, genders.name) as gender_name,
        brands.name
      FROM categories, genders, brands, item_models
        LEFT JOIN sub_categories ON item_models.sub_category_id = sub_categories.id
        INNER JOIN products ON item_models.id = products.item_model_id
        INNER JOIN styles ON styles.product_id = products.id
      WHERE item_models.category_id = categories.id
        AND item_models.gender_id = genders.id
        AND item_models.brand_id = brands.id
        AND styles.hidden = 0
      GROUP BY item_models.brand_id, item_models.category_id, item_models.sub_category_id, item_models.gender_id
    SQL

    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.execute("TRUNCATE countings")
    ActiveRecord::Base.connection.execute(category_counts_sql)
  end

end


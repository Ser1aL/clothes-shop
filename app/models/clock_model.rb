class ClockModel < ActiveRecord::Base

  # Deprecated. To be removed

  define_index do
    indexes model_unique_number
    indexes watch_case
    indexes strap
    indexes clock_face
    #indexes color
  end

  # change to sphinx when 2.0+ is well tested
  def self.search query, page
    query = "%#{query.strip}%"
    joins(:color, :category, :brand, :sub_category).where('
      clock_models.model_unique_number like ? or 
      clock_models.watch_case like ? or 
      clock_models.strap like ? or 
      clock_models.clock_face like ? or 
      clock_models.color like ? or 
      colors.name like ? or
      brands.name like ? or
      clock_categories.name like ? or
      sub_categorys.name like ?
      ', query, query, query, query, query, query, query, query, query).page(page).per(6)
  end

end

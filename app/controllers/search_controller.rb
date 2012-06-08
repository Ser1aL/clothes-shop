class SearchController < ApplicationController
  def index
    @category_countings =  Counting.where(:brand_id => nil).order(:sub_category_name).group_by(&:category_id)
    @item_models = ItemModel.get_items
  end

  # next actions respond to Ajax Search Calls
  def preload_categories
  end

  def preload_sub_categories
  end

  def preload_brands
  end

  def preload_genders
  end

  def preload_sizes
  end

  def preload_colors
  end

  def preload_facet_list    
  end

end

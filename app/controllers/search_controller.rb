class SearchController < ApplicationController
  respond_to :json
  layout 'application', :only => :index

  def index
    @category_countings =  CategoryCounting.order(:category_name).group_by(&:category_id)
    @brand_countings =  CategoryCounting.group(:brand_id).select("sum(value) as value, brand_name, brand_id")
    @gender_countings =  CategoryCounting.group(:gender_id).select("sum(value) as value, gender_name, gender_id")
    @item_models = ItemModel.get_items
  end

  # next actions respond to Ajax Search Calls
  def preload_categories
    respond_with RawSearch.get_counts(params, :category, @exchange_rate, @markup)
  end

  def preload_sub_categories
    respond_with RawSearch.get_counts(params, :sub_category, @exchange_rate, @markup)
  end

  def preload_brands
    respond_with RawSearch.get_counts(params, :brand, @exchange_rate, @markup)
  end

  def preload_genders
    respond_with RawSearch.get_counts(params, :gender, @exchange_rate, @markup)
  end

  def preload_sizes
    respond_with RawSearch.get_size_counts(params, @exchange_rate, @markup)
  end

  def preload_colors
    respond_with RawSearch.get_color_counts(params, @exchange_rate, @markup)
  end

  def preload_facet_list
    respond_with nil
  end

  def load_items
    @item_models = ItemModel.get_items_extended(params, @exchange_rate, @markup)
    render :layout => false
  end

end

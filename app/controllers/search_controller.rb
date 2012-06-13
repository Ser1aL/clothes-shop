class SearchController < ApplicationController
  respond_to :json
  layout 'application', :only => :index

  def index
    @category_countings =  CategoryCounting.order(:sub_category_name).group_by(&:category_id)
    @gender_countings =  GenderCounting.order(:gender_name)
    @item_models = ItemModel.get_items
  end

  # next actions respond to Ajax Search Calls
  def preload_categories
    respond_with RawSearch.get_counts(params, :category)
  end

  def preload_sub_categories
    respond_with RawSearch.get_counts(params, :sub_category)
  end

  def preload_brands
    respond_with RawSearch.get_counts(params, :brand)
  end

  def preload_genders
    respond_with RawSearch.get_counts(params, :gender)
  end

  # TODO optimize size search and style search

  def preload_sizes
    countings = ItemModel.get_items_extended(params).where("stocks.size IS NOT NULL").group_by{|item_model| item_model.product.styles.first.stocks.first.size}
    respond_with countings.collect{|not_used, count_group|
      {
          :count => count_group.size,
          :type_name => count_group.first.product.styles.first.stocks.first.size,
          :size => count_group.first.product.styles.first.stocks.first.size
      }.merge!(params)
    }.sort_by{|result| result[:type_name] }
  end

  def preload_colors
    countings = ItemModel.get_items_extended(params).group_by{|item_model| item_model.product.styles.first.color}
    respond_with countings.collect{|not_used, count_group|
      {
          :count => count_group.size,
          :type_name => count_group.first.product.styles.first.color,
          :color => count_group.first.product.styles.first.color
      }.merge!(params)
    }.sort_by{|result| result[:type_name]}
  end

  def preload_facet_list
    respond_with nil
  end

  def load_items
    @item_models = ItemModel.get_items_extended(params).page(params[:page]).per(6)
  end

end

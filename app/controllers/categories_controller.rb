require 'addressable/uri'

class CategoriesController < ApplicationController

  caches_action :show, :layout => false, :cache_path => Proc.new { |c| c.params }, :expires_in => 1.hour

  def show
    # filter heavy requests
    if params[:category].blank? && params[:sub_category].blank? && params[:gender].blank? && params[:brand].blank?
      @running_root_request = true
      if params[:price_range].present? || params[:color].present? || params[:size].present?
        redirect_to category_path(params[:top_level_cat_id]) and return
      end
    end

    @set_no_index = true if request.fullpath =~ /\?/

    top_level_category_id = params[:id] || params[:top_level_cat_id]
    @category_id = params[:category]
    @brand_id = params[:brand]
    @brand = Brand.find(@brand_id) if @brand_id.present?
    @sub_category_id = params[:sub_category]
    @gender = params[:gender]

    if @category_id.present?
      @categories = [Category.find(@category_id)]
    else
      @categories = Category.find_all_by_top_category(top_level_category_id)
    end

    if @running_root_request
      @styles = Style.get_items(params, @exchange_rate, @markup)
    else
      @styles = Style.get_items_extended(params, @exchange_rate, @markup)
    end


    # if page is category root get from countings and disable price/color/size
    if @running_root_request
      @category_counts =  CategoryCounting.joins(:category).
          where('categories.top_category = ?', top_level_category_id).
          order(:category_name).group_by(&:category_id).
          sort_by{|_, countings| countings.sum(&:value) }.reverse.first(15)
      @brand_counts =  CategoryCounting.joins(:category).
          where('categories.top_category = ?', top_level_category_id).
          group(:brand_id).select("sum(value) as value, brand_name, brand_id").
          limit(15)
      @gender_counts =  CategoryCounting.joins(:category).
          where('categories.top_category = ?', top_level_category_id).
          group(:gender_id).select("sum(value) as value, gender_name, gender_id").
          limit(15)
    else
      @sub_categories_counts = RawSearch.get_counts(params, :sub_category, @exchange_rate, @markup)
      @brand_counts = RawSearch.get_counts(params, :brand, @exchange_rate, @markup)
      @gender_counts = RawSearch.get_counts(params, :gender, @exchange_rate, @markup)
      @size_counts = RawSearch.get_size_counts(params, @exchange_rate, @markup)
      @color_counts = RawSearch.get_color_counts(params, @exchange_rate, @markup)
    end
  end

end

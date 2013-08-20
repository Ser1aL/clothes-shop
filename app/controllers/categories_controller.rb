require 'addressable/uri'

class CategoriesController < ApplicationController

  caches_action :show, :layout => false, :cache_path => Proc.new { |c| c.params }, :expires_in => 1.hour

  def show
    # filter heavy requests
    if params[:category].blank? && params[:sub_category].blank? && params[:gender].blank?
      @running_root_request = true
      if params[:price_range].present? || params[:color].present? || params[:size].present?
        redirect_to category_path(params[:top_level_cat_id]) and return
      end
    end

    # prepare request uri
    base_uri = category_url(params[:top_level_cat_id])
    uri_params = { :filter => 'y' }

    [:category, :sub_category, :gender, :price_range, :color, :size].each do |param|
      uri_params[param] = params[param] if params[param].present?
    end
    uri = Addressable::URI.new
    uri.query_values = uri_params
    @current_request_uri = base_uri + '?' + uri.query

    # ---

    top_level_category_id = params[:id] || params[:top_level_cat_id]
    @category_id = params[:category]

    if @category_id.present?
      @categories = [Category.find(@category_id)]
    else
      @categories = Category.find_all_by_top_category(top_level_category_id)
    end

    if @running_root_request
      @item_models = ItemModel.get_items(params, @exchange_rate, @markup)
    else
      @item_models = ItemModel.get_items_extended(params, @exchange_rate, @markup)
    end


    # if page is category root get from countings and disable price/color/size
    if params[:category].blank? && params[:sub_category].blank? && params[:gender].blank?
      @category_counts =  CategoryCounting.order(:category_name).group_by(&:category_id).sort_by{|_, countings| countings.sum(&:value) }.reverse.first(15)
      @brand_counts =  CategoryCounting.group(:brand_id).select("sum(value) as value, brand_name, brand_id").limit(15)
      @gender_counts =  CategoryCounting.group(:gender_id).select("sum(value) as value, gender_name, gender_id").limit(15)
    else
      @sub_categories_counts = RawSearch.get_counts(params, :sub_category, @exchange_rate, @markup)
      @gender_counts = RawSearch.get_counts(params, :gender, @exchange_rate, @markup)
      @size_counts = RawSearch.get_size_counts(params, @exchange_rate, @markup)
      @color_counts = RawSearch.get_color_counts(params, @exchange_rate, @markup)
    end

    @male_brands = Brand.joins(:item_models => [:category]).
        where('categories.id in (?)', @categories.map(&:id)).
        where("brands.logo_url IS NOT NULL AND brands.logo_url != ''").
        where("item_models.gender_id IN(2,3)").
        group('brands.id').limit(30)

    @female_brands = Brand.joins(:item_models => [:category]).
        where('categories.id in (?)', @categories.map(&:id)).
        where("brands.logo_url IS NOT NULL AND brands.logo_url != ''").
        where("item_models.gender_id IN(1,5)").
        group('brands.id').limit(30)

    @kids_brands = Brand.joins(:item_models => [:category]).
        where('categories.id in (?)', @categories.map(&:id)).
        where("brands.logo_url IS NOT NULL AND brands.logo_url != ''").
        where("item_models.gender_id IN(6,7)").
        group('brands.id').limit(30)

  end

  def prepare_raw_request_uri

  end

end

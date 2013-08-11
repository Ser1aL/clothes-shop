class CategoriesController < ApplicationController

  before_filter :filter_heavy_requests, only: %w(show)

  def show
    top_level_category_id = params[:id] || params[:top_level_cat_id]
    @category_id = params[:category]

    if @category_id.present?
      @categories = [Category.find(@category_id)]
    else
      @categories = Category.find_all_by_top_category(top_level_category_id)
    end

    @item_models = ItemModel.get_items(params)

    # if page is root get from countings and disable price/color/size
    if params[:category].blank? && params[:sub_category].blank? && params[:gender].blank?
      @category_countings =  CategoryCounting.order(:category_name).group_by(&:category_id).sort_by{|_, countings| countings.sum(&:value) }.reverse.first(15)
      @brand_countings =  CategoryCounting.group(:brand_id).select("sum(value) as value, brand_name, brand_id").limit(15)
      @gender_countings =  CategoryCounting.group(:gender_id).select("sum(value) as value, gender_name, gender_id").limit(15)
    else
      @sub_categories_countings = RawSearch.get_counts(params, :sub_category, @exchange_rate, @markup)
      @brand_countings = RawSearch.get_counts(params, :brand, @exchange_rate, @markup)
      @gender_countings = RawSearch.get_counts(params, :gender, @exchange_rate, @markup)
    end

    @brands = Brand.joins(:item_models => [:category]).
        where('categories.id in (?)', @categories.map(&:id)).
        where("brands.logo_url IS NOT NULL AND brands.logo_url != ''").
        group('brands.id').
        page(params[:brand_page]).per(30)

  end

  private

  def filter_heavy_requests
    if params[:category].blank? && params[:sub_category].blank? && params[:gender].blank?
      @running_root_request = true
      if params[:price_range].present? || params[:color].present? || params[:size].present?
        redirect_to category_path(params[:top_level_cat_id])
      end
    end
  end

end

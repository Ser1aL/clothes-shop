class CategoriesController < ApplicationController
  def show
    top_level_category_id = params[:id] || params[:top_level_cat_id]
    @category_id = params[:category]

    if @category_id.present?
      @categories = [Category.find(@category_id)]
    else
      @categories = Category.find_all_by_top_category(top_level_category_id)
    end

    @item_models = ItemModel.get_items(params)

    @gender_countings = RawSearch.get_counts(params, :gender, @exchange_rate, @markup)
    @sub_categories_countings = RawSearch.get_counts(params, :sub_category, @exchange_rate, @markup)
    @brand_countings = RawSearch.get_counts(params, :brand, @exchange_rate, @markup)

    @brands = Brand.joins(:item_models => [:category]).
        where('categories.id in (?)', @categories.map(&:id)).
        where("brands.logo_url IS NOT NULL AND brands.logo_url != ''").
        group('brands.id').
        page(params[:brand_page]).per(30)
  end

end

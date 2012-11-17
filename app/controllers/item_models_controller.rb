class ItemModelsController < ApplicationController
  def index
    if request.xhr?
      @categories = Category.all.group_by(&:top_category).delete_if{ |key, _| key.blank? }
      @countings = CategoryCounting.grouped_by_category
      @banners = Banner.where("banners.category_id IS NULL")
    end
  end

  def show
    @product = ItemModel.find(params[:id])
    @style = @product.product.styles.find(params[:style_id])
    update_prices @product, @style
  end

  def preload
    prepare_counts_with_conditions
    @item_models = ItemModel.get_items(params)
  end

  def search
    @products = ItemModel.search(params[:search_query], params[:page])
  end

  private

  def prepare_counts_with_conditions
    @brand_counts = CategoryCounting.counts_with_favorite(:brand, params)
    @brand_total_counts = @brand_counts.map{|hash| hash['item_count']}.sum

    @category_counts = CategoryCounting.counts_with_favorite(:category, params)
    @category_total_counts = @category_counts.map{|hash| hash['item_count']}.sum

    @sub_category_counts = CategoryCounting.counts_with_favorite(:sub_category, params)
    @sub_category_total_counts = @sub_category_counts.map{|hash| hash['item_count']}.sum

    @gender_counts = CategoryCounting.counts_with_favorite(:gender, params)
    @gender_total_counts = @gender_counts.map{|hash| hash['item_count']}.sum
  end

  private

  def update_prices(item_model, style)
    begin
      if style.update_6pm_prices(item_model)
        style.update_attribute(:hidden, false) and return
      end
    rescue
    end
    begin
      if style.update_zappos_prices(item_model)
        style.update_attribute(:hidden, false)
      else
        style.update_attribute(:hidden, true)
      end
    rescue
    end
  end

end

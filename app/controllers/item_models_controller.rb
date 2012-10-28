class ItemModelsController < ApplicationController
  def index
    if request.xhr?
      @countings = CategoryCounting.grouped_by_category
      @banners = Banner.where("banners.category_id IS NULL")
    end
  end

  def show
    @product = ItemModel.find(params[:id])
    @style = @product.product.styles.find(params[:style_id])
  end

  def preload
    prepare_counts_with_conditions
    File.open('f.txt', 'a+'){|f| f.puts params.inspect}
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

end

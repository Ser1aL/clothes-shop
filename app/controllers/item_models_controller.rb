class ItemModelsController < ApplicationController
  def index
    @products = ItemModel.latest(params[:page])
  end

  def show
    @product = ItemModel.find(params[:id])
    @style = @product.product.styles.find(params[:style_id])
  end

  def preload
    @brand_counts = ItemModel.counts_by_type(:brand)
    @brand_total_counts = @brand_counts.map{|hash| hash['item_count']}.sum

    @category_counts = ItemModel.counts_by_type(:category)
    @category_total_counts = @category_counts.map{|hash| hash['item_count']}.sum

    @sub_category_counts = ItemModel.counts_by_type(:sub_category)
    @sub_category_total_counts = @sub_category_counts.map{|hash| hash['item_count']}.sum

    @color_counts = ItemModel.counts_by_type(:color)
    @color_total_counts = @color_counts.map{|hash| hash['item_count']}.sum
    @item_models = ItemModel.get_items(params)
  end
  
  def search
    @products = ItemModel.search(params[:search_query], params[:page])
  end

end

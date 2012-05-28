class ItemModelsController < ApplicationController
  def index
    if request.xhr?
      @countings = Counting.where(:brand_id => nil).order(:sub_category_name).group_by(&:category_id)
      @banners = Banner.where("banners.category_id IS NULL")
    end
  end

  def show
    @product = ItemModel.find(params[:id])
    @style = @product.product.styles.find(params[:style_id])
  end

  def preload
    @item_models = ItemModel.get_items(params)
  end

  def search
    @products = ItemModel.search(params[:search_query], params[:page])
  end

end

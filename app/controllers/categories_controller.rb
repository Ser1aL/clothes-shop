class CategoriesController < ApplicationController
  def show
    @categories = Category.find_all_by_top_category(params[:id])
    @banners = []
    @countings = CategoryCounting.grouped_by_category
  end

end

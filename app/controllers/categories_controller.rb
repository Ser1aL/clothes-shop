class CategoriesController < ApplicationController
  def show
    @categories = Category.find_all_by_top_category(params[:id])
    @banners = Banner.where(:category_id => params[:id])
    @banners = Banner.where(:category_id => nil) if @banners.none?
    @countings = CategoryCounting.grouped_by_category
  end

end

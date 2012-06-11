class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @countings = CategoryCounting.where(:category_id => params[:id])
  end

end

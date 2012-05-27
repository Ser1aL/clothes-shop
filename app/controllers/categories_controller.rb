class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @countings = Counting.where(:brand_id => nil, :category_id => params[:id])
  end

end

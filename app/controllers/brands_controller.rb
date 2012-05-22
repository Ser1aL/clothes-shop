class BrandsController < ApplicationController
  def index
    @brands = begin
      if params[:letter]
        Brand.find_by_letter(params[:letter]).order(:name)
      elsif params[:category_id]
        Brand.find_by_category_id(params[:category_id]).order(:name)
      else
        Brand.order(:name).all.group_by{ |brand| brand.name.downcase.first }
      end
    end
  end

  def show
    @brand = Brand.find(params[:id])
    @category_tree = @brand.build_category_tree
  end

end

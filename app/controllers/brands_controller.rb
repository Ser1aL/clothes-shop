class BrandsController < ApplicationController
  def index
    @brands = begin
      if params[:letter]
        Brand.find_by_letter(params[:letter])
      elsif params[:category_id]
        Brand.find_by_category_id(params[:category_id])
      else
        Brand.all
      end
    end
  end

  def show
    @brand = Brand.find(params[:id])
  end

end

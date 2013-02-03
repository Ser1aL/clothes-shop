class SubCategoriesController < ApplicationController
  def show
    @sub_category = Category.includes(:item_models => [:gender, :brand]).find(params[:id])
    @gender_map = {}
    @brands = []
    @sub_category.item_models.each do |item|
      gender_name = item.gender.display_name || item.gender.name
      @gender_map[gender_name] ||= {}
      @gender_map[gender_name][:count] ||= 0
      @gender_map[gender_name][:id] ||= item.gender.id
      @gender_map[gender_name][:count] += 1
      @brands << item.brand unless @brands.include?(item.brand)
    end
  end

end

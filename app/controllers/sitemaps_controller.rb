class SitemapsController < ApplicationController

  def index
    @categories =Category.where("top_category is not null").all.group_by(&:top_category)
    @brands = Brand.group(:name).order(:name).group_by{ |brand| brand.name.downcase.first }
  end
end
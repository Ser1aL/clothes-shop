class ErrorsController < ApplicationController


  def not_found
    @categories = Category.all.group_by(&:top_category).delete_if{ |key, _| key.blank? }
    @countings = CategoryCounting.grouped_by_category
  end

  def internal_server_error
  end

end
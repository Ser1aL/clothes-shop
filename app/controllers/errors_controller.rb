class ErrorsController < ApplicationController


  def not_found
    @categories = Category.all.group_by(&:top_category).delete_if{ |key, _| key.blank? }
    @countings = CategoryCounting.grouped_by_category
    render :status => 404
  end

  def internal_server_error
    render :status => 500
  end

end
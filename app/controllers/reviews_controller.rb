class ReviewsController < ApplicationController

  def index
    @reviews = Review.where(:verified => true)
  end

  def create
    Review.create(params[:review])
    flash[:message_type] = 'review_added'
    redirect_to root_path
  end

end

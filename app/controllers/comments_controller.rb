class CommentsController < ApplicationController
  def create
    @comment = ItemModel.find(params[:item_model_id]).comments.create(:body => params[:comment_body], :user_id => current_user.try(:id))
    redirect_to :back
  end

  def destroy
    @comment = Comment.find(params[:comment_id])
    @comment.destroy if @comment.user == current_user
  end

end

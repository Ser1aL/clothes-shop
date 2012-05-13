class CommentsController < ApplicationController
  def create
    item_model = ItemModel.find(params[:item_model_id])
    @comment = Comment.create(:body => params[:comment_body], :user => current_user)
    item_model.comments << @comment
    item_model.save
  end

  def destroy
    @comment = Comment.find(params[:comment_id])
    @comment.destroy if @comment.user == current_user
  end

end

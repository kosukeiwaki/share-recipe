class CommentsController < ApplicationController

  def create
    Comment.create(comment_params)
  end

  def show
    @comment = Comment.new
    @comments = @recipe.comments.includes(:user)
  end

  private
  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id, recipe_id: params[:recipe_id])
  end
end

class CommentsController < ApplicationController

  def create
    comment = Comment.create(comment_params)
    redirect_to "/recipes/#{comment.recipe.id}"
  end

  def show
    @comment = Comment.new
    @comments = @recipe.comments.includes(:user).order(created_at: :desc)
  end

  private
  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id, recipe_id: params[:recipe_id])
  end
end

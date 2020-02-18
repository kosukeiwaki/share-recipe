class RecipesController < ApplicationController

  def index
    @recipes = Recipe.all.order(created_at: :desc)
    @likes = Like.where(user_id: current_user.id)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id
    @recipe.name = current_user.name
    if @recipe.save
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
    @like = Like.new
    @comments = @recipe.comments.includes(:user)
  end

  def destroy
    recipe = Recipe.find(params[:id])
    recipe.destroy
    redirect_to root_path
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    recipe = Recipe.find(params[:id])
    recipe.update(recipe_params)
    redirect_to root_path
  end

  private
  def recipe_params
    params.require(:recipe).permit(:name, :title, :image, :text)
  end

end

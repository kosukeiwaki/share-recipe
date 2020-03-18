class RecipesController < ApplicationController
  before_action :authenticate_user!, except: [:create,:search]

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
      flash[:notice] = '画像、テキスト、料理名を入力してください'
      redirect_to new_recipe_path
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
    if recipe.update(recipe_params)
      redirect_to root_path
    else
      flash[:alert] = '画像、テキスト、料理名を入力してください'
      render edit_recipe_path
    end
  end

  def search
    @recipes = Recipe.search(params[:keyword])
    respond_to do |format|
      format.html
      format.json
    end
  end

  # def random
  #   @randoms = Recipe.order(“RAND()“).limit(1)
  #   @random = Recipe.new
  #   if params[:submit]
  #     @random.score += 1
  #   elsif params[:btn2]
  #     @random.score -= 1
  #   end
  # end

  private
  def recipe_params
    params.require(:recipe).permit(:name, :title, :image, :text)
  end

end

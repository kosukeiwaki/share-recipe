class Recipes::SearchesController < ApplicationController

  def index
    @recipes = Recipe.search(params[:keyword])
  end

end

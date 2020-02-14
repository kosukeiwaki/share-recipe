class LikesController < ApplicationController
    before_action :authenticate_user!
    
    def create
      @like = current_user.likes.create(recipe_id: params[:recipe_id])
      redirect_back(fallback_location: root_path)
    end

    def destroy
      @like = Like.find_by(recipe_id: params[:recipe_id], user_id: current_user.id)
      @like.destroy
      redirect_back(fallback_location: root_path)
    end
    
end

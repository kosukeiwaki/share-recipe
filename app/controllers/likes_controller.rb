class LikesController < ApplicationController
    before_action :authenticate_user
    
    def create
      @like = Like.new(
        user_id: @current_user.id,
        recipe_id: params[:recipe_id]
      )
      @like.save
      redirect_to root_path
    end

    def destroy
      @like = Like.find_by(user_id: @current_user.id, recipe_id: params[:recipe_id])
      @like.destroy
      redirect_to root_path
    end
    
end

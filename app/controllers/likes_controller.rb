class LikesController < ApplicationController
    before_action :authenticate_user!
    
    def create
      @like = current_user.likes.create(recipe_id: params[:recipe_id])
      redirect_back(fallback_location: root_path)
      flash[:notice] = 'お気に入りに登録されました' 
    end

    def destroy
      @like = Like.find_by(recipe_id: params[:recipe_id], user_id: current_user.id)
      @like.destroy
      redirect_back(fallback_location: root_path)
      flash[:notice] = 'お気に入りを解除しました' 
    end
    
end

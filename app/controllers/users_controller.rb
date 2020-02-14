class UsersController < ApplicationController

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    user = User.find(user_params)
    if user.destroy
      redirect_to root_path
    end
  end
  private

  def user_params
    params.require(:user).permit(:name, :email)
  end

end

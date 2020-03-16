class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         has_many :recipes
         has_many :likes

        #  def show_users
        #     @users = Group.find[params[:id]]
        #     if @users.present?
        #       <% @users.each do|user| %>
        #        <%= user.name %>
        #        <% end %>
        #     else
        #       'メンバーがいません'
        #     end
        #  end
end

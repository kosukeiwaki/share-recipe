class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         has_many :recipes
         has_many :likes

         def already_liked?(recipe)
          likes.exists?(recipe_id: recipe.id)
        end
end

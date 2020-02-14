class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  has_many :comments
  has_many :recipes
  has_many :likes
  has_many :liked_posts, through: :likes
  def already_liked?(recipe)
    self.likes.exists?(recipe_id: recipe.id)
  end
end

class Recipe < ApplicationRecord
  validates :text, presence: true
  belongs_to :user
  has_many :comments
  has_many :liked_users, through: :likes
  has_many :likes
  belongs_to :user

  def self.search(search)
    return Recipe.all unless search
    Recipe.where('title LIKE(?)', "%#{search}%")
  end
end

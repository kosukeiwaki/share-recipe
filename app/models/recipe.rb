class Recipe < ApplicationRecord
  validates :text, presence: true
  validates :title, presence: true
  validates :image, presence: true
  belongs_to :user
  has_many :comments
  has_many :liked_users, through: :likes
  has_many :likes
  belongs_to :user
  mount_uploader :image, ImageUploader

  def self.search(search)
    if search
      Recipe.where('title LIKE(?)', "%#{search}%")
    else
      Recipe.all
    end
  end

 
end

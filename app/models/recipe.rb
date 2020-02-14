class Recipe < ApplicationRecord
  validates :text, presence: true
  belongs_to :user
  has_many :comments
  has_many :liked_users, through: :likes
  has_many :likes
  belongs_to :user
end

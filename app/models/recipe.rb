class Recipe < ApplicationRecord
  validates :text, presence: true
  belongs_to :user
  has_many :comments
  belongs_to :user
end

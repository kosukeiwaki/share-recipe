class Like < ApplicationRecord
  validates :user_id, {presence: true}
  validates :recipe_id, {presence: true}

  belongs_to :user, dependent: :destroy
  belongs_to :recipe, dependent: :destroy
end

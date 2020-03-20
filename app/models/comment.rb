class Comment < ApplicationRecord
  validates :user_id, {presence: true}
  validates :recipe_id, {presence: true}
  validates :text, presence: true

  belongs_to :recipe, dependent: :destroy
  belongs_to :user, dependent: :destroy
end

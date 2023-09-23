class Thought < ApplicationRecord
  belongs_to :user
  validates :title, length: { minimum: 3, maximum: 30 }
  validates :content, length: { minimum: 5, maximum: 1500 }
  has_many :user_favorite_thoughts, dependent: :destroy
  has_many :user_hidden_thoughts, dependent: :destroy
  has_many :favorited_by_users, through: :user_favorite_thoughts, source: :user
  has_many :hidden_by_users, through: :user_hidden_thoughts, source: :user
end

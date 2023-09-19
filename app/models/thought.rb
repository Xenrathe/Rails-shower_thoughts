class Thought < ApplicationRecord
  belongs_to :user
  validates :title, length: { minimum: 3, maximum: 30 }
  validates :content, length: { minimum: 5, maximum: 1500 }
end

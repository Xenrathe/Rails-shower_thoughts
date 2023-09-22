class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :thoughts
  has_many :user_favorite_thoughts
  has_many :user_hidden_thoughts
  has_many :favorite_thoughts, through: :user_favorite_thoughts, source: :thought
  has_many :hidden_thoughts, through: :user_hidden_thoughts, source: :thought

end

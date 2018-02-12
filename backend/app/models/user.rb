class User < ApplicationRecord
  validates :username, uniqueness: true
  has_many :user_movies
  has_many :movies, through: :user_movies
end

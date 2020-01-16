class Movie < ApplicationRecord
  acts_as_followable
  has_many :movies_genre
  has_many :genres, through: :movies_genre

  has_many :movies_star
  has_many :stars, through: :movies_star

  scope :suggests_movies, ->(stars_ids, genres_ids) {
  	joins(:stars, :genres).where('stars.id IN (?) OR genres.id IN (?)', stars_ids, genres_ids).uniq 
  }
end

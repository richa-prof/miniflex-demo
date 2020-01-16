class MoviesController < ApplicationController
  before_action :find_movie, except: [:index]

  def index
    if params[:tab].nil? || params[:tab] == "Movie"
      @page_tab = "movies"
      @movies = Movie.includes(:genres, :stars).all.page(params[:page]).per_page(20)
    elsif params[:tab] == "Genre"
      @page_tab = "genres"
      @genres = Genre.all.page(params[:page]).per_page(20)
    elsif params[:tab] == "Star"
      @page_tab = "stars"
      @stars = Star.all.page(params[:page]).per_page(20)
    elsif params[:tab] == "Suggest"
      @movies = []
      @page_tab = "suggest"

      return unless Follow.any?
      user_follows
      # genre_names = fetch_genre_names
      # star_names = fetch_star_names
      # @movies_by_genres = Movie.joins(:genres).where(genres: {name: genre_names}).uniq
      # @movies_by_stars = Movie.joins(:stars).where(stars: { name: star_names}).uniq
      # @movies = @movies_by_genres | @movies_by_stars
    end
  end

  def follow
    current_user.follow(@object)
    respond_to do |format|
      format.html { redirect_to action: "index", tab: params[:type] }
      format.js
    end
  end

  def unfollow
    current_user.stop_following(@object)
    respond_to do |format|
      format.html { redirect_to action: "index", tab: params[:type] }
      format.js
    end
  end

  private

  def find_movie
    @object = params[:type].constantize.find(params[:id])
  end

  def user_follows
    stars_ids = current_user.follows_by_type('Stars').map(&:followable_id)
    genres_ids = current_user.follows_by_type('Genre').map(&:followable_id)
    @movies = Movie.suggests_movies(stars_ids, genres_ids)
  end

  def fetch_follow_movies
    @movies_ids ||= current_user.follows_by_type('Movie').map(&:followable_id)
  end
end

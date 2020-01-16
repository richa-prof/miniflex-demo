require 'will_paginate/array'
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
    @movies = Movie.suggests_movies(stars_ids, genres_ids).paginate(:page => params[:page], :per_page => 20)
  end

  def fetch_follow_movies
    @movies_ids ||= current_user.follows_by_type('Movie').map(&:followable_id)
  end
end

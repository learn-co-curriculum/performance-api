class Api::V1::MoviesController < ApplicationController
  before_action :current_movie, only: [:show]
  def index
    @movies = Movie.all
    render json: @movies, status: 201
  end

  def show
    render json: @movie, status: 200
  end

  private
  def current_movie
    @movie = Movie.find(params[:id])
  end
end

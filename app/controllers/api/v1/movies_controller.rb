class Api::V1::MoviesController < ApplicationController
  def index
    @movies = Movie.all
    render json: @movies, status: 201
  end
end

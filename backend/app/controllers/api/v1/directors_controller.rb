class Api::V1::DirectorsController < ApplicationController

  def index
    @directors = Director.includes(:movies).limit(25)
    render json: @directors, status: 200
  end

  def show
    @director = Director.includes(:movies).find(params[:id])
    render json: @director, status: 200
  end

end

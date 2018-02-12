class Api::V1::UsersController < ApplicationController

  def index
    @users = User.includes(:movies).limit(15)
    render json: @users, status: 200
  end

  def show
    # @user = User.find(params[:id])
    # render json: { user: @user, movies: @user.movies }, status: 200

    @user = User.includes(:movies).find(params[:id]).explain
    render json: @user, status: 200
  end

  def profile
    # @user = User.find_by(username: params[:username])
    # render json: { user: @user, movies: @user.movies }, status: 200

    @user = User.includes(:movies).find_by(username: params[:username])
    render json: @user, status: 200
  end

end

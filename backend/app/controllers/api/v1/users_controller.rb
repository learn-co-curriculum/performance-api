class Api::V1::UsersController < ApplicationController

  def index
    # no eager loading
    # @users = User.all

    # eager loading:
    @users = User.includes(:movies).all

    render json: @users, status: 200
  end

  def show
    @user = User.find(params[:id])
    # @user = User.includes(:movies).find(params[:id])
    render json: @user, status: 200
  end

  def profile
    @user = User.find_by(username: params[:username])
    render json: @user, status: 200
  end

end

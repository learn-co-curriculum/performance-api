class Api::V1::UsersController < ApplicationController

  def index
    @users = User.limit(25)
    render json: @users, status: 200
  end

  def show
    @user = User.find(params[:id])
    render json: @user, status: 200
  end

  def profile
    @user = User.find_by(username: params[:username])
    render json: @user, status: 200
  end

end

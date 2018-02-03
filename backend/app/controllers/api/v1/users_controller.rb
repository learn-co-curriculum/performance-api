class Api::V1::UsersController < ApplicationController

  def index
    @users = User.all.limit(50)
    render json: @users, status: 200
  end

  def show
    render json: User.find(params[:id]), status: 200
  end

  def profile
    @user = User.find_by(username: params[:username])
    render json: @user, status: 200
  end

end

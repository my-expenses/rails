class UsersController < ApplicationController
  before_action :authorized, only: [:refresh_token, :status]

  def register
    user = User.create(user_params)

    if user.valid?
      render json: {message: "success"}
    else
      render json: {message: user.errors, status: 401}, status: :bad_request
    end
  end

  def login
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      token = encode_token({user_id: user.id})
      render json: {accessToken: token, message: "success"}
    else
      render json: {message: "Invalid credentials", status: 401}, status: :unauthorized
    end
  end

  private
  def user_params
    params.permit(:fullName, :password, :email, :password_confirmation)
  end
end

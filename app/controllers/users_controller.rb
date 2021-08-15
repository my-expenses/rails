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
      token = encode_token({user_id: user.id}, 15.minutes.from_now.to_i) # 15 minutes
      refresh_token = encode_token({user_id: user.id}, 10.days.from_now.to_i) # 10 days
      render json: {accessToken: token, refreshToken: refresh_token, message: "success"}
    else
      render json: {message: "Invalid credentials", status: 401}, status: :unauthorized
    end
  end

  def refresh_token
    if get_user_id == 0
      render json: {message: "Error generating access token", status: 500}, status: :internal_server_error
      return
    end
    token = encode_token({user_id: get_user_id}, 15.minutes.from_now.to_i) # 15 minutes
    refresh_token = encode_token({user_id: get_user_id}, 10.days.from_now.to_i)
    render json: {accessToken: token, refreshToken: refresh_token, message: "success"}
  end

  private
  def user_params
    params.permit(:fullName, :password, :email, :password_confirmation)
  end
end

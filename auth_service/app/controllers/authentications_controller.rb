class AuthenticationsController < ApplicationController
  def register
    user = User.new(user_params)
    if user.save
      token = User.encode_token({user_id: user.id})
      render json: {user: user, token: token, message: "User created successfully"}, status: :created
    else
      render json: {error: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: user_params[:email])
    if user
      if user.authenticate(user_params[:password])
        token = User.encode_token({user_id: user.id})
        render json: {user: user, token: token, message: "Logged in sucessfully"}, status: :ok
      else
        render json: {error: 'Invalid password'}, status: :unauthorized
      end
    else
      render json: {error: 'Invalid email'}, status: :unauthorized
    end
  end

  private
  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end

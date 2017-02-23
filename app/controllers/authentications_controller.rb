class AuthenticationsController < ApplicationController
  skip_before_action :authenticate_user!

  def register
    puts user_params
    user = User.new(user_params)
    watchlist = Watchlist.new
    user.watchlist = Watchlist.last
    if user.save
      token = Auth.issue({id: user.id})
      render json: { token: token, user: UserSerializer.new(user) }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      token = Auth.issue({id: user.id})
      render json: { token: token, user: UserSerializer.new(user) }, status: :ok
    else
      render json: { errors: ["Invalid login credentials."]}, status: 401
    end
  end

  # method which can only be used in this file
  # sets user_params to only the params we want/expect
  private
    def user_params
      hash = {}
      hash.merge! params.slice(:email, :password, :password_confirmation)
      hash
    end
end

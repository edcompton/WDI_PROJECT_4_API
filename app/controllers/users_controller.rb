class UsersController < ApplicationController
  skip_before_action :authenticate_user!

  # def index
  #   companies = Company.all
  #   render json: companies
  # end

  def show
    puts params
    user = User.find(1)
    p user
    render json: {user: user}
  end
end

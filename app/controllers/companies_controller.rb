class CompaniesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    companies = Company.all
    render json: companies
  end

  def model_show
    ticker = params['ticker']
    show_model_hash = Company.get_show_model_hash ticker
    render json: show_model_hash
  end

end

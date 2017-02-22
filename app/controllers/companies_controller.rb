class CompaniesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    companies = Company.all
    render json: companies
  end

  def model_show
    ticker = params['ticker']
    company = Company.find_by ticker: ticker
    render json: company
  end

end

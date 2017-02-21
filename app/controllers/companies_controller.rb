class CompaniesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    companies = Company.all
    render json: companies
  end

  def show
  end
end

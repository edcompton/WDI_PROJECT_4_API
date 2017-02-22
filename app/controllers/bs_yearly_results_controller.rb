class BsYearlyResultsController < ApplicationController
  skip_before_action :authenticate_user!
  def show
    render json: Company.first.filings.last.bs_yearly_results.first
  end
end

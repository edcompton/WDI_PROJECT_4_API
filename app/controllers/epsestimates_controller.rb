class EpsestimatesController < ApplicationController
  require 'open-uri'
  require 'httparty'

  def eps_estimates
    ticker = params['ticker']
    url = "https://query2.finance.yahoo.com/v10/finance/quoteSummary/#{ticker}?formatted=true&crumb=aiUUOqOuMGO&lang=en-US&region=US&modules=upgradeDowngradeHistory%2CrecommendationTrend%2CfinancialData%2CearningsHistory%2CearningsTrend&corsDomain=finance.yahoo.com"
    response = HTTParty.get(url)
    x = response.parsed_response

    y0 = x['quoteSummary']['result'][0]['earningsTrend']['trend'][2]
    y1 = x['quoteSummary']['result'][0]['earningsTrend']['trend'][3]
    eps_estimate_0 = y0['earningsEstimate']['avg']['raw']
    eps_estimate_1 = y1['earningsEstimate']['avg']['raw']
    estimate_0_year = y0['endDate'][0..3]
    estimate_1_year = y1['endDate'][0..3]

    render json: {
      eps_estimate_0: eps_estimate_0,
      eps_estimate_1: eps_estimate_1,
      estimate_0_year: estimate_0_year,
      estimate_1_year: estimate_1_year,
    }
  end
end


# https://query2.finance.yahoo.com/v10/finance/quoteSummary/aapl?formatted=true&crumb=aiUUOqOuMGO&lang=en-US&region=US&modules=description%2CsummaryProfile%2CrecommendationTrend%2CearningsTrend&corsDomain=finance.yahoo.com

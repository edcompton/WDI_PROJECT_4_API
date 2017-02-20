class HistoricalpricesController < ApplicationController

  def historical_prices
    tickers = params["_json"]
    priceHistory = []
    tickers.each_with_index do |ticker, index|
      url = "http://query.yahooapis.com/v1/public/yql?q=
      select * from   yahoo.finance.historicaldata
               where  symbol    = '#{ticker}'
               and    startDate = '2016-01-01'
               and    endDate   = '2017-02-18'
      &format=json
      &diagnostics=true
      &env=store://datatables.org/alltableswithkeys
      &callback="

      response = HTTParty.get(url)

      priceHistory[index] = response['query']['results']['quote']

    end
    render json:  { priceHistory: priceHistory }
  end
end

require 'open-uri'
require 'httparty'

tickers = ['AAPL','GOOG']

tickers.each do |ticker|
  url = "https://query2.finance.yahoo.com/v10/finance/quoteSummary/#{ticker}?formatted=true&crumb=aiUUOqOuMGO&lang=en-US&region=US&modules=description%2CsummaryProfile&corsDomain=finance.yahoo.com"
  response = HTTParty.get(url)
  x = response.parsed_response

  tickerHash = {}

  tickerHash['symbol'] = "#{ticker}"
  tickerHash['description'] = x['quoteSummary']['result'][0]['description']['longBusinessSummary']
  tickerHash['short_description'] = x['quoteSummary']['result'][0]['description']['description']
  tickerHash['sector'] = x['quoteSummary']['result'][0]['summaryProfile']['sector']

  puts tickerHash

  sleep 1
end



# https://query2.finance.yahoo.com/v10/finance/quoteSummary/aapl?formatted=true&crumb=aiUUOqOuMGO&lang=en-US&region=US&modules=description%2CsummaryProfile%2CrecommendationTrend%2CearningsTrend&corsDomain=finance.yahoo.com

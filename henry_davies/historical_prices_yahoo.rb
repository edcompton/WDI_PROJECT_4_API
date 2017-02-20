require 'httparty'
require 'date'

stocks = ['AAPL','KO','PG','GOOG', 'EUR=X', 'GBP=X', 'JPY=X', 'AUD=X']

stocks.each do |ticker|
  url = "http://query.yahooapis.com/v1/public/yql?q=
  select * from   yahoo.finance.historicaldata
           where  symbol    = '#{ticker}'
           and    startDate = '2016-01-01'
           and    endDate   = '#{Date.today.strftime("%Y-%m-%d")}'
  &format=json
  &diagnostics=true
  &env=store://datatables.org/alltableswithkeys
  &callback="

  response = HTTParty.get(url)
  priceHistory = response['query']['results']['quote']
  puts priceHistory
end

# url for live stock price api requests (from front-end): https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22AAPL%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=

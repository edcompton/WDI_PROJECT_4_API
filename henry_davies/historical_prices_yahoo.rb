require 'httparty'
require 'date'

stocks = ['AAPL','KO','PG','GOOG']

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

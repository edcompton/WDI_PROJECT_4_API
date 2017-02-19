require 'httparty'

stocks = ['AAPL','KO','PG','GOOG']

stocks.each do |ticker|
  puts ticker
  url = "http://query.yahooapis.com/v1/public/yql?q=
  select * from   yahoo.finance.historicaldata
           where  symbol    = '#{ticker}'
           and    startDate = '2016-01-01'
           and    endDate   = '2017-02-18'
  &format=json
  &diagnostics=true
  &env=store://datatables.org/alltableswithkeys
  &callback="

  puts url

  response = HTTParty.get(url)

  priceHistory = p response['query']['results']['quote']

  puts priceHistory

end

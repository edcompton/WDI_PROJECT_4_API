require 'open-uri'
require 'httparty'

ticker = 'AAPL'

url = "https://query2.finance.yahoo.com/v10/finance/quoteSummary/#{ticker}?formatted=true&crumb=aiUUOqOuMGO&lang=en-US&region=US&modules=upgradeDowngradeHistory%2CrecommendationTrend%2CfinancialData%2CearningsHistory%2CearningsTrend%2CindustryTrend%2CindexTrend%2CsectorTrend&corsDomain=finance.yahoo.com"

response = HTTParty.get(url)
x = response.parsed_response
y0 = x['quoteSummary']['result'][0]['earningsTrend']['trend'][2]
y1 = x['quoteSummary']['result'][0]['earningsTrend']['trend'][3]

puts y0['earningsEstimate']['avg']['raw']
puts y1['earningsEstimate']['avg']['raw']

puts y0['endDate'][0..3]


# https://query2.finance.yahoo.com/v10/finance/quoteSummary/aapl?formatted=true&crumb=aiUUOqOuMGO&lang=en-US&region=US&modules=upgradeDowngradeHistory%2CrecommendationTrend%2CfinancialData%2CearningsHistory%2CearningsTrend%2CindustryTrend%2CindexTrend%2CsectorTrend&corsDomain=finance.yahoo.com

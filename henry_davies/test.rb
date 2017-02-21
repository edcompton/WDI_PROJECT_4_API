require 'open-uri'
require 'nokogiri'

ticker = 'AAPL'

url = "https://finance.yahoo.com/quote/#{ticker}/analysts"


page = Nokogiri::HTML(open(url))

puts page


# [@class='BdT']

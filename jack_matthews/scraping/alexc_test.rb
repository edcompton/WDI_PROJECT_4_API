require 'nokogiri'
require 'open-uri'
require 'pry'

# html = File.open('table.html', 'r').read

html = 'https://www.sec.gov/Archives/edgar/data/320193/000162828016020309/R2.htm'
doc = Nokogiri::HTML(open(html))

# get table headers
headers = []
doc.xpath('//*/table/tr/th').each do |th|
  headers << th.text
end

# get table rows
rows = []
doc.xpath('//*/table/tr').each_with_index do |row, i|
  rows[i] = {}
  row.xpath('td').each_with_index do |td, j|
    rows[i][headers[j]] = td.text
  end
end

binding.pry

p rows

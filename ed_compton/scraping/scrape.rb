# request.headers["Cookie"]
#
#
# general.headers["Request-URL"]

require 'nokogiri'
require 'open-uri'
require 'pry'

ticker = "GOOG"
link_array = []

xml = "https://www.sec.gov/cgi-bin/browse-edgar?CIK=#{ticker}&Find=Search&owner=exclude&action=getcompany&output=atom&type=10-k"
doc = Nokogiri::XML(open(xml))

puts doc

# doc.css('filing-href').each do |x|
#   link_array << (x.text.split('/')[0..-2] << "R2.htm").join('/')
# end
#
# puts link_array

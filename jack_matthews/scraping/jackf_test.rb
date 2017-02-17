require 'open-uri'
require 'nokogiri'

url = "https://www.sec.gov/cgi-bin/viewer?action=view&cik=320193&accession_number=0001628280-16-020309&xbrl_type=v#"

html = open(url)

apple = Nokogiri::HTML(html)

report = apple.css('td')
p report


 require 'pdf-reader'
 reader = PDF::Reader.new('')
 reader.pages.each do |page|
  p page.text
 end

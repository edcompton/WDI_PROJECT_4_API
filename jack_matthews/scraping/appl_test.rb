require 'nokogiri'

html_file = File.open("apple_IS.html")

doc = Nokogiri::HTML.parse(html_file)

date_divs = doc.xpath('//div[text() = "Sep. 24, 2016"]/../../th/div')

dates_array = []
date_divs.each do |date|
  dates_array << date.text
end

row_titles = ["Net sales", "Cost of sales", "Gross margin", "Research and development", "Selling, general and administrative", "Total operating expenses", "Operating income", "Other income/(expense), net", "Income before provision for income taxes", "Provision for income taxes", "Net income", "Basic (in dollars per share)", "Diluted (in dollars per share)", "Basic (in shares)", "Diluted (in shares)", "Cash dividends declared per share (in dollars per share)"]

row_titles.each_with_index do |title, i|
  puts title
  columns = doc.xpath("//a[text() = '#{title}']/../../td[@class='nump']")
  columns.each_with_index do |column, j|
    puts dates_array[j] + ": " + column.text
  end
end


# doc.xpath('//tr').each_with_index do |row, i|
#   puts "\nTitle : "+row.xpath('//a')[i].text
#   row.xpath('td')[1..-1].each_with_index do |column, j|
#     puts "\nValue : "+column.text
#   end
# end

# doc.xpath('//tr').each_with_index do |row, i|
#   puts "\nTitle : "+row.xpath('//a')[i].text
#   row.xpath('td')[1..-1].each_with_index do |column, j|
#     puts "\nValue : "+column.text
#   end
# end

# doc.xpath('//sitcom').each do |sitcom_element|
#   puts "\nShow Name : "+sitcom_element.xpath('name').text
#   count=1
#   sitcom_element.xpath('characters/character').each do |character_element|
#     puts "    #{count}.Charachter : " + character_element.text
#     count=count+1
#   end
# end

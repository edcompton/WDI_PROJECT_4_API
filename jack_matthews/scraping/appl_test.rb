require 'nokogiri'

html_file = File.open("apple_IS.html")

doc = Nokogiri::HTML.parse(html_file)

doc.xpath('//tr').each_with_index do |row, i|
  puts "\nTitle : "+row.xpath('//a')[i].text
  row.xpath('td')[1..-1].each_with_index do |column, j|
    puts "\nValue : "+column.text
  end

end

# doc.xpath('//sitcom').each do |sitcom_element|
#   puts "\nShow Name : "+sitcom_element.xpath('name').text
#   count=1
#   sitcom_element.xpath('characters/character').each do |character_element|
#     puts "    #{count}.Charachter : " + character_element.text
#     count=count+1
#   end
# end

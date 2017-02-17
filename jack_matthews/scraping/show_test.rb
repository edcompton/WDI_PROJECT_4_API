require 'nokogiri'

xml_file = File.read("shows.xml")

doc = Nokogiri::XML.parse(xml_file)

doc.xpath('//sitcom').each do

  |sitcom_element|

  puts "\nShow Name : "+sitcom_element.xpath('name').text
  count=1
  sitcom_element.xpath('characters/character').each do

    |character_element|

    puts "    #{count}.Charachter : " + character_element.text
    count=count+1



  end

end

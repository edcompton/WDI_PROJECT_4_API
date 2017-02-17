# Look for any element with an onclick attribute, and read the value of that element.
# Save that element in a variable and extract the values from the child elements of that element.
require 'open-uri'
require 'nokogiri'

File.delete("apple.xml")
blank_file = File.new("apple.xml", "w+")

apple_balance_sheet = ("/Users/jackfuller/development/WDI_PROJECT_4_API/raw_htmls/balance_sheets/apple_BS.xml")

@doc = File.open(apple_balance_sheet) { |f| Nokogiri::XML(f) }

# x = @doc.xpath("//cashandcashequivalent")
# x = @doc.css('td')
# val = @doc.xpath("//a and text() = Cash And Cash Equivalents")
val = @doc.xpath("//a//@onclick")
val.each do |onclick|
  if (onclick.value.include? "Cash")
    p onclick
    p onclick.xpath("/td")
  end

end

def find_cash_cash_equivalents

end


# File.open(blank_file, "w") { |file| file.write(onclick)}
# xml = open(url)

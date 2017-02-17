# # Look for any element with an onclick attribute, and read the value of that element.
# # Save that element in a variable and extract the values from the child elements of that element.
require 'open-uri'
require 'nokogiri'
#
# # File.delete("apple.xml")
blank_file = File.new("henry_onclicks", "w+")

apple_balance_sheet = ("/Users/jackfuller/development/WDI_PROJECT_4_API/raw_htmls/balance_sheets/apple_BS.xml")

@doc = File.open(apple_balance_sheet) { |f| Nokogiri::XML(f) }

# array of onclicks
header = []
# possible onclick names - cash and cash equivalnts
cash_cash_equivalents = ["CashAndCashEquivalentsAtCarryingValue"]

def number_or_nil(string)
  Integer(string || '')
rescue ArgumentError
  nil
end

# Initiliase the date array
# Find the dates - this ssumes they're in the same position in every balance sheet - and add them to array.
def find_earliest_year
date_array = []
dates = @doc.xpath("//body//tr//th[@class='th']")
dates.each do |i|
  i = number_or_nil i.text.split(',')[1]
  date_array.push(i)
  p date_array
 end

end
find_earliest_year

# def find_values cce_xml_node
#   node = cce_xml_node.xpath("./../../../td[@class = 'nump']")
#   p node.text
# end
#
# onclicks = @doc.xpath("//a//@onclick")
# onclicks.each do |onclick|
#   if onclick.value.include? cash_cash_equivalents[0]
#     p onclick.value.split(',')[1]
#     find_values onclick
#   elsif onclick.value.include? "AvailableForSaleSecuritiesCurrent"
#     p onclick.value.split(',')[1]
#     find_values onclick
#   end
# end

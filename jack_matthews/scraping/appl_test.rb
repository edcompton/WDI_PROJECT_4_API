IS = {
  dates: [],
  "2016": {
    Sales: {
      on_click_title: "SalesRevenueNet",
      row_title: "SalesRevenueNet",
      value: 215678
    },
    COGS: {
      on_click_title: "CostOfGoodsAndServicesSold",
      value: 145000
    }
  },
  "2015": {
    Sales: {
      on_click_title: "SalesRevenueNet",
      value: 215678
    },
    COGS: {
      on_click_title: "CostOfGoodsAndServicesSold",
      value: 145000
    }
  }
}

class IncomeStatementParser


end





require 'nokogiri'
require 'pp'
require 'pry'

html_file = File.open("apple_IS.html")

doc = Nokogiri::HTML.parse(html_file)

date_divs = doc.xpath('//div[text() = "Sep. 24, 2016"]/../../th/div')

appl_IS_2016 = {}
appl_IS_2016[:dates] = []

date_divs.each do |date|
  appl_IS_2016[:dates] << date.text
  appl_IS_2016[date.text[-4..-1].to_sym] = {}
end

# array within an array / not really
# make part of class
# stick below array in a yml file

on_click_phrases = ["SalesRevenueNet", "CostOfGoodsAndServicesSold", "GrossProfit", "ResearchAndDevelopmentExpense", "SellingGeneralAndAdministrativeExpense", "OperatingExpenses", "OperatingIncomeLoss", "NonoperatingIncomeExpense", "IncomeLossFromContinuingOperationsBeforeIncomeTaxesExtraordinaryItemsNoncontrollingInterest", "IncomeTaxExpenseBenefit", "NetIncomeLoss", "EarningsPerShareBasic", "EarningsPerShareDiluted", "WeightedAverageNumberOfSharesOutstandingBasic", "WeightedAverageNumberOfDilutedSharesOutstanding", "CommonStockDividendsPerShareDeclared"]

# p appl_IS_2016

on_click_phrases.each_with_index do |on_click, i|
  cells = doc.xpath("//a[contains(@onclick, '#{on_click}')]/../../td[@class='nump']")

  cells.each_with_index do |cell, j|
    appl_IS_2016[date_divs[j].text[-4..-1].to_sym][on_click.to_sym] = {}
    appl_IS_2016[date_divs[j].text[-4..-1].to_sym][on_click.to_sym][:title] = on_click
    appl_IS_2016[date_divs[j].text[-4..-1].to_sym][on_click.to_sym][:value] = cell.text.gsub(/[^\d]/, '').to_i

  end
end

Pry::ColorPrinter.pp(appl_IS_2016)

# row_titles = ["Net sales", "Cost of sales", "Gross margin", "Research and development", "Selling, general and administrative", "Total operating expenses", "Operating income", "Other income/(expense), net", "Income before provision for income taxes", "Provision for income taxes", "Net income", "Basic (in dollars per share)", "Diluted (in dollars per share)", "Basic (in shares)", "Diluted (in shares)", "Cash dividends declared per share (in dollars per share)"]
#
# row_titles.each_with_index do |title, i|
#   puts title
#   columns = doc.xpath("//a[text() = '#{title}']/../../td[@class='nump']")
#   columns.each_with_index do |column, j|
#     puts dates_array[j] + ": " + column.text
#   end
# end


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

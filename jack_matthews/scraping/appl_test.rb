require 'nokogiri'
require 'pp'
require 'pry'

html_file = File.open("apple_IS.html")
doc = Nokogiri::HTML.parse(html_file)

document_period_end_date = "Sep. 24, 2016"

# array within an array / not really
# make part of class
# stick below array in a yml file

on_click_phrases = ["SalesRevenueNet", "CostOfGoodsAndServicesSold", "GrossProfit", "ResearchAndDevelopmentExpense", "SellingGeneralAndAdministrativeExpense", "OperatingExpenses", "OperatingIncomeLoss", "NonoperatingIncomeExpense", "IncomeLossFromContinuingOperationsBeforeIncomeTaxesExtraordinaryItemsNoncontrollingInterest", "IncomeTaxExpenseBenefit", "NetIncomeLoss", "EarningsPerShareBasic", "EarningsPerShareDiluted", "WeightedAverageNumberOfSharesOutstandingBasic", "WeightedAverageNumberOfDilutedSharesOutstanding", "CommonStockDividendsPerShareDeclared"]

# initialise final hash object
appl_IS_2016 = {}

# find cell which matches doc period end date
# (meta data of filing) mavigate up the DOM
# to capture statement column headers (dates)
date_divs = doc.xpath("//div[text() = '#{document_period_end_date}']/../../th/div")

# get strings from array of column header nokogiri objects
date_strings = date_divs.collect do |div|
  div.text
end

# get '2016' from date strings
date_symbols = date_strings.collect do |string|
  string[-4..-1].to_sym
end

# push date_strings into dates array on final hash
appl_IS_2016[:dates] = date_strings

# push empty hash for each year into finished hash
date_symbols.each do |symbol|
  appl_IS_2016[symbol] = {}
end

# search html for each row using onclick labels
on_click_phrases.each_with_index do |on_click_phrase, i|
  # get nokogiri object for each value cell
  nokogiri_objects = doc.xpath("//a[contains(@onclick, '#{on_click_phrase}')]/../../td[@class='nump']")

  # push values from nokogiri_object and onclick titles
  # NOTE current regex expression removes decimal points!
  # into final hash under appropriate year and title
  nokogiri_objects.each_with_index do |nokogiri_object, j|
    appl_IS_2016[date_symbols[j]][on_click_phrase.to_sym] = {
      title: on_click_phrase,
      value: nokogiri_object.text.gsub(/[^\d]/, '').to_i
    }
  end
end

# print out final hash in pretty colors
Pry::ColorPrinter.pp(appl_IS_2016)

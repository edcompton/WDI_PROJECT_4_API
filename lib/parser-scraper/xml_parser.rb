require 'nokogiri'
require 'pp'
require 'pry'

onclick_values = {
  SALES: ["SalesRevenueNet", "SalesRevenueGoodsNet","Revenues"],
  COGS: ["CostOfGoodsAndServicesSold","CostOfGoodsSold","CostOfRevenue"],
  EBIT: ["OperatingIncomeLoss"],

  PBT: ["IncomeLossFromContinuingOperationsBeforeIncomeTaxesExtraordinaryItemsNoncontrollingInterest","IncomeLossFromContinuingOperationsBeforeIncomeTaxes","IncomeLossFromContinuingOperationsBeforeIncomeTaxesMinorityInterestAndIncomeLossFromEquityMethodInvestments"],

  TAX: ["IncomeTaxExpenseBenefit"],
  NET_INCOME: ["NetIncomeLoss","NetIncomeLossAvailableToCommonStockholdersBasic"],

  BASIC_EPS: ["EarningsPerShareBasic"],
  DILUTED_EPS: ["EarningsPerShareDiluted"]
}

class HtmlParser

  def open_file file_name
    @doc_to_parse = File.open(file_name)
  end

  def parse_file
    @doc_to_scrape = Nokogiri::HTML.parse(@doc_to_parse)
  end

end

class IncomeStatementScraper < HtmlParser

  def initialize_data_hash
    @appl_data = {}
  end

  def get_document_period_end_date
    query = "//body//tr//th[@class='th']"
    @document_period_end_date = @doc_to_scrape.xpath(query)[1].text
  end

  def get_date_divs
    query = "//div[text() = '#{@document_period_end_date}']/../../th/div"
    @date_divs = @doc_to_scrape.xpath(query)
  end

  def get_date_strings
    @date_strings = @date_divs.collect{ |div| div.text}
  end

  def get_date_symbols
    @date_symbols = @date_strings.collect do |string|
      string[-4..-1].to_sym
    end
  end

  def set_date_array_on_data_hash
    @appl_data[:dates] = @date_strings
  end

  def set_year_hashes_on_data_hash
    @date_symbols.each do |symbol|
      @appl_data[symbol] = {}
    end
  end

  def populate_data_hash array
    array.each_with_index do |on_click_phrase, i|
      # get nokogiri object for each value cell
      nokogiri_objects = @doc_to_scrape.xpath("//a[contains(@onclick, '#{on_click_phrase}')]/../../td[@class='nump']")

      # push values from nokogiri_object and onclick titles
      # NOTE current regex expression removes decimal points!
      # into final hash under appropriate year and title
      nokogiri_objects.each_with_index do |nokogiri_object, j|
        @appl_data[@date_symbols[j]][on_click_phrase.to_sym] = {
          title: on_click_phrase,
          value: nokogiri_object.text.gsub(/[^\d]/, '').to_i
        }
      end
    end
  end


  def initialize file
    initialize_data_hash
    open_file file
    parse_file
    get_document_period_end_date
    get_date_divs
    get_date_strings
    get_date_symbols
    set_date_array_on_data_hash
    set_year_hashes_on_data_hash
    populate_data_hash ["SalesRevenueNet", "CostOfGoodsAndServicesSold", "GrossProfit", "ResearchAndDevelopmentExpense", "SellingGeneralAndAdministrativeExpense", "OperatingExpenses", "OperatingIncomeLoss", "NonoperatingIncomeExpense", "IncomeLossFromContinuingOperationsBeforeIncomeTaxesExtraordinaryItemsNoncontrollingInterest", "IncomeTaxExpenseBenefit", "NetIncomeLoss", "EarningsPerShareBasic", "EarningsPerShareDiluted", "WeightedAverageNumberOfSharesOutstandingBasic", "WeightedAverageNumberOfDilutedSharesOutstanding", "CommonStockDividendsPerShareDeclared"]
    p @appl_data
  end


end

file = "/Users/jackfuller/development/WDI_PROJECT_4_API/raw_htmls/income_statements/apple_IS.html"

IS = IncomeStatementScraper.new(file)
# IS.initialize_data_hash
# IS.open_file file
# IS.parse_file
# IS.get_document_period_end_date
# IS.get_date_divs
# IS.get_date_strings
# IS.get_date_symbols
# IS.set_date_array_on_data_hash
# IS.set_year_hashes_on_data_hash

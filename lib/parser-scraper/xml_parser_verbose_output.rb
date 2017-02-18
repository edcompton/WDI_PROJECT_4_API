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

  def initialize_data_hash
    @data = {}
  end

  def get_nokogiri_objects query
    @doc_to_scrape.xpath(query)
  end

  def get_date_strings
    @date_strings = @date_divs.collect{ |div| div.text}
  end

  def get_date_symbols
    @date_symbols = @date_strings.collect do |string|
      string[-4..-1].to_sym
    end
  end

end



class IncomeStatementScraper < HtmlParser
# Test on balance sheet and cash flow etc and move up class tree if generic
  def get_document_period_end_date
    query = "//body//tr//th[@class='th']"
    @document_period_end_date = @doc_to_scrape.xpath(query)[1].text
  end

  # Test on balance sheet and cash flow etc and move up class tree if generic
  def get_date_divs
    query = "//div[text() = '#{@document_period_end_date}']/../../th/div"
    @date_divs = @doc_to_scrape.xpath(query)
  end

  def set_date_array_on_data_hash
    @data[:dates] = @date_strings
  end

  def set_year_hashes_on_data_hash
    @date_symbols.each do |symbol|
      @data[symbol] = {}
    end
  end

  def populate_data_hash hash
    hash.each do |key, value|
      value.each do |onclick_phrase|
        nokogiri_objects = get_nokogiri_objects("//a[contains(@onclick, '#{onclick_phrase}')]/../../td[@class='nump']")
        populate_data_hash_with_cells nokogiri_objects, onclick_phrase, key
      end
    end
  end

  def populate_data_hash_with_cells nokogiri_objects, onclick_phrase, model_title
    nokogiri_objects.each_with_index do |nokogiri_object, j|
      populate_data_hash_with_cell nokogiri_object, j, onclick_phrase, model_title
    end
  end

  def populate_data_hash_with_cell nokogiri_object, j, onclick_phrase, model_title
    @data[@date_symbols[j]][model_title] = create_cell_hash onclick_phrase, nokogiri_object
  end

  def create_cell_hash onclick_phrase, nokogiri_object
    {
      title: onclick_phrase,
      value: nokogiri_object.text.gsub(/[^\d|.]/, '').to_f
    }
  end

  def initialize file, onclick_values
    initialize_data_hash
    open_file file
    parse_file
    get_document_period_end_date
    get_date_divs
    get_date_strings
    get_date_symbols
    set_date_array_on_data_hash
    set_year_hashes_on_data_hash
    populate_data_hash onclick_values
    Pry::ColorPrinter.pp(@data)
  end


end

file = "/Users/jackfuller/development/WDI_PROJECT_4_API/raw_htmls/income_statements/apple_IS.html"

IS = IncomeStatementScraper.new file, onclick_values

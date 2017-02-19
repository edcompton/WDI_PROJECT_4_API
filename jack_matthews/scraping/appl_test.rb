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

  def initialize_data_array
    @data = []
  end

  def get_nokogiri_objects query
    @doc_to_scrape.xpath(query)
  end

  def get_date_divs
    query = "//body//tr//th[@class='th']"
    @date_divs = get_nokogiri_objects(query)[1..-1]
  end

  def get_date_strings
    @date_strings = @date_divs.collect do |div|
      div.text.gsub(/\n/, "").strip
    end
  end

  def get_year_integer date_string
    date_string.gsub(/[^\d]/, '')[-4..-1].to_i
  end

  def get_document_period_end_date
    query = "//body//tr//th[@class='th']"
    @document_period_end_date = get_nokogiri_objects(query)[1].text
  end

  def populate_data_array_with_cells
    @date_strings.each_with_index do |date, index|
      @data[index] = create_yearly_results_hash date, index
    end
  end

  def get_cell_float key_symbol, column_index
    @onclick_values[key_symbol].each do |onclick_phrase|
      query = "//a[contains(@onclick, '#{onclick_phrase}')]/../../td[@class='nump']"
      object = get_nokogiri_objects(query)[column_index]
      next unless object
      return nokogiri_object_to_float object
    end
  end

  def nokogiri_object_to_float nokogiri_object
    nokogiri_object.text.gsub(/[^\d|.]/, '').to_f
  end

end

class IncomeStatementScraper < HtmlParser

  def create_yearly_results_hash date, column_index
    {
      IS_id: 1,
      year: get_year_integer(date),
      date: date,
      SALES: get_cell_float(:SALES, column_index),
      COGS: get_cell_float(:COGS, column_index),
      EBIT: get_cell_float(:EBIT, column_index),
      PBT: get_cell_float(:PBT, column_index),
      TAX: get_cell_float(:TAX, column_index),
      NET_INCOME: get_cell_float(:NET_INCOME, column_index),
      BASIC_EPS: get_cell_float(:BASIC_EPS, column_index),
      DILUTED_EPS: get_cell_float(:DILUTED_EPS, column_index)
    }
  end

  def initialize file, onclick_values
    @onclick_values = onclick_values
    open_file file
    parse_file
    initialize_data_array
    get_date_divs
    get_date_strings
    get_document_period_end_date
    populate_data_array_with_cells
    Pry::ColorPrinter.pp(@data)
  end

end

file = "./apple_IS.html"

IS = IncomeStatementScraper.new file, onclick_values

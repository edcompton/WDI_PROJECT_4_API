require "nokogiri"
require "pry"
require "pp"

bs_onclick_values = {
  CCE: ["_CashAndCashEquivalentsAtCarryingValue\'"],
  MARKETABLE_SECURITIES: ["_AvailableForSaleSecuritiesCurrent\'"],
  SHORT_TERM_INVESTMENTS: [],
  INVENTORY: ["_InventoryNet\'"],
  ACCOUNTS_RECIEVABLE: ["_AccountsReceivableNetCurrent\'"],
  TOTAL_CURRENT_ASSETS: ["_AssetsCurrent\'"],
  AVAIABLE_FOR_SALE_SECURITIES: ["_AvailableForSaleSecuritiesNoncurrent\'"],
  PPE_NET: ["_PropertyPlantAndEquipmentNet\'"],
  GOODWILL: ["_Goodwill\'"],
  OTHER_INTANGIBLE_ASSETS: ["_IntangibleAssetsNetExcludingGoodwill\'"],
  TOTAL_ASSETS: ["_Assets\'"],
  ACCOUNTS_PAYABLE: ["_AccountsPayableCurrent\'"],
  ACCRUED_EXPENSES: ["_AccruedLiabilitiesCurrent\'"],
  SHORT_TERM_DEBT: ["_CommercialPaper\'"],
  CURRENT_PORTION_OF_LONG_TERM_DEBT: ["_LongTermDebtCurrent\'"],
  CURRENT_DEFERRED_REVENUE: ["_DeferredRevenueNoncurrent\'"],
  TOTAL_CURRENT_LIABILITIES: ["_LiabilitiesCurrent\'"],
  LONG_TERM_DEBT: ["_LongTermDebtNoncurrent\'"],
  NON_CURRENT_DEFERRED_REVENUE: ["_DeferredRevenueNoncurrent\'"],
  DEFERRED_TAX_LIABILITIES: [],
  TOTAL_LIABILITIES: ["_Liabilities\'"],
  COMMON_STOCKS_AND_PAID_IN_CAPITAL: ["_CommonStocksIncludingAdditionalPaidInCapital\'"],
  RETAINED_EARNINGS: ["_RetainedEarningsAccumulatedDeficit\'"],
  ACCUMULATED_OTHER_COMPREHENSIVE_INCOME: ["_AccumulatedOtherComprehensiveIncomeLossNetOfTax\'"],
  TREASURY_STOCK: [],
  MINORITY_INTEREST: [],
  TOTAL_EQUITY: ["_StockholdersEquity\'"],
  TOTAL_LIABILITIES_AND_EQUITY: ["_LiabilitiesAndStockholdersEquity\'"]
}

class ParserAndScraper
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
    @date_divs = @doc_to_scrape.xpath(query)
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
    @document_period_end_date = @doc_to_scrape.xpath(query)[1].text
  end


  def populate_data_array_with_cells
    @date_strings.each_with_index do |date, index|
      @data[index] = create_yearly_results_hash date, index
    end
  end
  def nokogiri_object_to_float nokogiri_object

    nokogiri_object.text.gsub(/[^\d|.]/, '').to_f
  end

  def is_integer? string
    string.to_i.to_s == string
  end
end

class BalanceSheetScraper < ParserAndScraper
  def create_yearly_results_hash date, column_index
    {
      IS_id: 1,
      year: get_year_integer(date),
      date: date,
      UNIT: get_units,
      CCE: get_cell_float(:CCE, column_index),
      MARKETABLE_SECURITIES: get_cell_float(:MARKETABLE_SECURITIES, column_index),
      SHORT_TERM_INVESTMENTS: get_cell_float(:SHORT_TERM_INVESTMENTS, column_index),
      INVENTORY: get_cell_float(:INVENTORY, column_index),
      ACCOUNTS_RECIEVABLE: get_cell_float(:ACCOUNTS_RECIEVABLE, column_index),
      TOTAL_CURRENT_ASSETS: get_cell_float(:TOTAL_CURRENT_ASSETS, column_index),
      AVAIABLE_FOR_SALE_SECURITIES: get_cell_float(:AVAIABLE_FOR_SALE_SECURITIES, column_index),
      PPE_NET: get_cell_float(:PPE_NET, column_index),
      GOODWILL: get_cell_float(:GOODWILL, column_index),
      OTHER_INTANGIBLE_ASSETS: get_cell_float(:OTHER_INTANGIBLE_ASSETS, column_index),
      TOTAL_ASSETS: get_cell_float(:TOTAL_ASSETS, column_index),
      ACCOUNTS_PAYABLE: get_cell_float(:ACCOUNTS_PAYABLE, column_index),
      ACCRUED_EXPENSES: get_cell_float(:ACCRUED_EXPENSES, column_index),
      SHORT_TERM_DEBT: get_cell_float(:SHORT_TERM_DEBT, column_index),
      CURRENT_PORTION_OF_LONG_TERM_DEBT: get_cell_float(:CURRENT_PORTION_OF_LONG_TERM_DEBT, column_index),
      CURRENT_DEFERRED_REVENUE: get_cell_float(:CURRENT_DEFERRED_REVENUE, column_index),
      TOTAL_CURRENT_LIABILITIES: get_cell_float(:TOTAL_CURRENT_LIABILITIES, column_index),
      LONG_TERM_DEBT: get_cell_float(:LONG_TERM_DEBT, column_index),
      NON_CURRENT_DEFERRED_REVENUE: get_cell_float(:NON_CURRENT_DEFERRED_REVENUE, column_index),
      DEFERRED_TAX_LIABILITIES: get_cell_float(:DEFERRED_TAX_LIABILITIES, column_index),
      TOTAL_LIABILITIES: get_cell_float(:TOTAL_LIABILITIES, column_index),
      COMMON_STOCKS_AND_PAID_IN_CAPITAL: get_cell_float(:COMMON_STOCKS_AND_PAID_IN_CAPITAL, column_index),
      RETAINED_EARNINGS: get_cell_float(:RETAINED_EARNINGS, column_index),
      ACCUMULATED_OTHER_COMPREHENSIVE_INCOME: get_cell_float(:ACCUMULATED_OTHER_COMPREHENSIVE_INCOME, column_index),
      TREASURY_STOCK: get_cell_float(:TREASURY_STOCK, column_index),
      MINORITY_INTEREST: get_cell_float(:MINORITY_INTEREST, column_index),
      TOTAL_EQUITY: get_cell_float(:TOTAL_EQUITY, column_index),
      TOTAL_LIABILITIES_AND_EQUITY: get_cell_float(:TOTAL_LIABILITIES_AND_EQUITY, column_index)
    }
  end

  def get_units
    query = "//tr/th/div/strong"
    obj = get_nokogiri_objects(query)
    obj = obj.text.split(')')[1].strip!
  end

  def get_cell_float key_symbol, column_index
    @bs_onclick_values[key_symbol].each do |title_phrase|
      query='//a[contains(@onclick, "'+ title_phrase + '")]/../../td[@class="nump"]'
      objects = get_nokogiri_objects(query)
      next if objects.length == 0
      p objects.length, "hi"
      objects.each{|object| p object.text}
      return nokogiri_object_to_float object
    end
  end

  def initialize file, bs_onclick_values
    @bs_onclick_values = bs_onclick_values
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
file = "/Users/jackfuller/development/WDI_PROJECT_4_API/raw_htmls/balance_sheets/apple_BS.html"
IS = BalanceSheetScraper.new file, bs_onclick_values

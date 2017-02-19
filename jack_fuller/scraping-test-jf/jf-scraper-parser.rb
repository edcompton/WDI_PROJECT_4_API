require 'nokogiri'
require 'pp'
require 'pry'

bs_onclick_values = {
  CCE: ["defref_us-gaap_CashAndCashEquivalentsAtCarryingValue"],
  MARKETABLE_SECURITIES: ["defref_us-gaap_AvailableForSaleSecuritiesCurrent"],
  SHORT_TERM_INVESTMENTS: [],
  INVENTORY: ["defref_us-gaap_InventoryNet"],
  ACCOUNTS_RECIEVABLE: ["defref_us-gaap_AccountsReceivableNetCurrent"],
  TOTAL_CURRENT_ASSETS: ["defref_us-gaap_AssetsCurrent"],
  AVAIABLE_FOR_SALE_SECURITIES: ["defref_us-gaap_AvailableForSaleSecuritiesNoncurrent"],
  PPE_NET: ["defref_us-gaap_PropertyPlantAndEquipmentNet"],
  GOODWILL: ["Goodwill"],
  OTHER_INTANGIBLE_ASSETS: ["IntangibleAssetsNetExcludingGoodwill"],
  TOTAL_ASSETS: ["Assets"],
  ACCOUNTS_PAYABLE: ["AccountsPayableCurrent"],
  ACCRUED_EXPENSES: ["AccruedLiabilitiesCurrent"],
  SHORT_TERM_DEBT: ["CommercialPaper"],
  CURRENT_PORTION_OF_LONG_TERM_DEBT: ["LongTermDebtCurrent"],
  CURRENT_DEFERRED_REVENUE: ["DeferredRevenueNoncurrent"],
  TOTAL_CURRENT_LIABILITIES: ["LiabilitiesCurrent"],
  LONG_TERM_DEBT: ["LongTermDebtNoncurrent"],
  NON_CURRENT_DEFERRED_REVENUE: ["DeferredRevenueNoncurrent"],
  DEFERRED_TAX_LIABILITIES: [],
  TOTAL_LIABILITIES: ["Liabilities"],
  COMMON_STOCKS_AND_PAID_IN_CAPITAL: ["CommonStocksIncludingAdditionalPaidInCapital"],
  RETAINED_EARNINGS: ["RetainedEarningsAccumulatedDeficit"],
  ACCUMULATED_OTHER_COMPREHENSIVE_INCOME: ["AccumulatedOtherComprehensiveIncomeLossNetOfTax"],
  TREASURY_STOCK: [],
  MINORITY_INTEREST: [],
  TOTAL_EQUITY: ["StockholdersEquity"],
  TOTAL_LIABILITIES_AND_EQUITY: ["LiabilitiesAndStockholdersEquity"]
}


bs_title_values = {
  CCE: ["Cash and cash equivalents"],
  MARKETABLE_SECURITIES: ["Short-term marketable securities"],
  SHORT_TERM_INVESTMENTS: [],
  INVENTORY: ["Inventories"],
  ACCOUNTS_RECIEVABLE: ["Accounts receivable, less allowances of $53 and $63, respectively"],
  TOTAL_CURRENT_ASSETS: ["Total current assets"],
  AVAIABLE_FOR_SALE_SECURITIES: ["Long-term marketable securities"],
  PPE_NET: ["Property, plant and equipment, net"],
  GOODWILL: ["Goodwill"],
  OTHER_INTANGIBLE_ASSETS: ["Acquired intangible assets, net"],
  TOTAL_ASSETS: ["Total assets"],
  ACCOUNTS_PAYABLE: ["Accounts payable"],
  ACCRUED_EXPENSES: ["Accrued expenses"],
  SHORT_TERM_DEBT: ["Commercial paper"],
  CURRENT_PORTION_OF_LONG_TERM_DEBT: ["Current portion of long-term debt"],
  CURRENT_DEFERRED_REVENUE: ["Deferred revenue, non-current"],
  TOTAL_CURRENT_LIABILITIES: ["Total current liabilities"],
  LONG_TERM_DEBT: ["Long-term debt"],
  NON_CURRENT_DEFERRED_REVENUE: ["Deferred revenue"],
  DEFERRED_TAX_LIABILITIES: [],
  TOTAL_LIABILITIES: ["Total liabilities"],
  COMMON_STOCKS_AND_PAID_IN_CAPITAL: ["Common stock and additional paid-in capital"],
  RETAINED_EARNINGS: ["Retained earnings"],
  ACCUMULATED_OTHER_COMPREHENSIVE_INCOME: ["Accumulated other comprehensive income/(loss)"],
  TREASURY_STOCK: [],
  MINORITY_INTEREST: [],
  TOTAL_EQUITY: ["Total shareholders&#8217; equity"],
  TOTAL_LIABILITIES_AND_EQUITY: ["Total liabilities and shareholders"]
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

  def get_date_strings
    @date_strings = @date_divs.collect{ |div| div.text}
  end

  def is_integer? string
    string.to_i.to_s == string
  end

  def get_date_symbols
    @date_strings.each_with_index do |date, index|
      if is_integer? date
        @date_strings.delete_at(index)
      end
    end
    @date_symbols = @date_strings.collect do |string|
      string[-4..-1].to_sym
    end.sort!
  end

  def get_document_period_end_date
    query = "//body//tr//th[@class='th']"
    @document_period_end_date = @doc_to_scrape.xpath(query)[1].text
  end

  def get_date_divs
    query = "//body//tr//th[@class='th']"
    @date_divs = @doc_to_scrape.xpath(query)
    @date_divs
  end

  def set_year_hashes_on_data_array
    @date_symbols.each do |symbol|
      year = symbol
      symbol = Hash.new(year: year)
      @data.push(symbol)
    end

  end

# Loop over the hashes, find the relvant noko object and extract the data.
  def populate_data_hash hash
    hash.each do |key, value|
      value.each do |onclick_phrase|
        nokogiri_object = get_nokogiri_objects("//a[text() = '#{onclick_phrase}']/../../td[@class='nump']/../../td[@class='nump']")
        populate_data_hash_with_cells nokogiri_object, onclick_phrase, key
      end
    end
  end

  def populate_data_hash_with_cells nokogiri_objects, onclick_phrase, model_title
    nokogiri_objects.each_with_index do |object, index|
      @data[index][model_title] = create_cell_hash onclick_phrase, object
    end
  end

  def create_cell_hash onclick_phrase, nokogiri_object
    {
      title: onclick_phrase,
      value: nokogiri_object.text.gsub(/[^\d|.]/, '').to_f
    }
  end

end

class BalanceSheetScraper < HtmlParser
  def initialize file, bs_title_values
    initialize_data_array
    open_file file
    parse_file
    get_document_period_end_date
    get_date_divs
    get_date_strings
    get_date_symbols
    set_year_hashes_on_data_array
    populate_data_hash bs_onclick_values
    Pry::ColorPrinter.pp(@data)
  end
end

file = "/Users/jackfuller/development/WDI_PROJECT_4_API/raw_htmls/balance_sheets/apple_BS.html"

BS = BalanceSheetScraper.new file, bs_onclick_values

# Look throught the nodeset

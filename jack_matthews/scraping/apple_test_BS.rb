require 'nokogiri'
require 'pp'
require 'pry'

bs_title_values = {
  CCE: ["Cash and cash equivalents"],
  MARKETABLE_SECURITIES: ["Short-term marketable securities"],
  SHORT_TERM_INVESTMENTS: [],
  INVENTORY: ["Inventories"],
  ACCOUNTS_RECIEVABLE: ["Accounts receivable", "Accounts receivable, less allowances of $53 and $63, respectively"],
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
  NON_CURRENT_DEFERRED_REVENUE: ["Deferred revenue, non-current"],
  DEFERRED_TAX_LIABILITIES: [],
  TOTAL_LIABILITIES: ["Total liabilities"],
  COMMON_STOCKS_AND_PAID_IN_CAPITAL: ["Common stock and additional paid-in capital, $0.00001 par value: 12,600,000 shares authorized; 5,336,166 and 5,578,753 shares issued and outstanding, respectively"],
  RETAINED_EARNINGS: ["Retained earnings"],
  ACCUMULATED_OTHER_COMPREHENSIVE_INCOME: ["Accumulated other comprehensive income/(loss)"],
  TREASURY_STOCK: [],
  MINORITY_INTEREST: [],
  TOTAL_EQUITY: ["Total shareholders&#8217; equity"],
  TOTAL_LIABILITIES_AND_EQUITY: ["Total liabilities and shareholders&#8217; equity"]
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

  def nokogiri_object_to_float nokogiri_object
    nokogiri_object.text.gsub(/[^\d|.]/, '').to_f
  end

  def is_integer? string
    string.to_i.to_s == string
  end

end

class IncomeStatementScraper < ParserAndScraper

  def create_yearly_results_hash date, column_index
    {
      IS_id: 1,
      year: get_year_integer(date),
      date: date,
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

  def get_cell_float key_symbol, column_index
    @bs_title_values[key_symbol].each do |title_phrase|
      query = "//a[text() = '#{title_phrase}']/../../td[@class='nump']"
      object = get_nokogiri_objects(query)[column_index]
      next unless object
      p nokogiri_object_to_float object
      return nokogiri_object_to_float object
    end
  end

  def initialize file, bs_title_values
    @bs_title_values = bs_title_values
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

file = "./apple_BS.html"

IS = IncomeStatementScraper.new file, bs_title_values

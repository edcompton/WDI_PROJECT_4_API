require 'nokogiri'
require 'pp'
require 'pry'
require 'yaml'
load 'ParserAndScraper.rb'

class CashflowStatementScraper < ParserAndScraper

  def get_date_divs
    query = "//body//tr//th[@class='th']"
    @date_divs = @doc_to_scrape.xpath(query)
  end

  def create_yearly_results_hash date, column_index
    {
      IS_id: 1,
      year: get_year_integer(date),
      date: date,
      UNIT: get_units,
      CCE: get_cell_float("CCE", column_index),
      MARKETABLE_SECURITIES: get_cell_float("MARKETABLE_SECURITIES", column_index),
      SHORT_TERM_INVESTMENTS: get_cell_float("SHORT_TERM_INVESTMENTS", column_index),
      INVENTORY: get_cell_float("INVENTORY", column_index),
      ACCOUNTS_RECIEVABLE: get_cell_float("ACCOUNTS_RECIEVABLE", column_index),
      TOTAL_CURRENT_ASSETS: get_cell_float("TOTAL_CURRENT_ASSETS", column_index),
      AVAIABLE_FOR_SALE_SECURITIES: get_cell_float("AVAIABLE_FOR_SALE_SECURITIES", column_index),
      PPE_NET: get_cell_float("PPE_NET", column_index),
      GOODWILL: get_cell_float("GOODWILL", column_index),
      OTHER_INTANGIBLE_ASSETS: get_cell_float("OTHER_INTANGIBLE_ASSETS", column_index),
      TOTAL_ASSETS: get_cell_float("TOTAL_ASSETS", column_index),
      ACCOUNTS_PAYABLE: get_cell_float("ACCOUNTS_PAYABLE", column_index),
      ACCRUED_EXPENSES: get_cell_float("ACCRUED_EXPENSES", column_index),
      SHORT_TERM_DEBT: get_cell_float("SHORT_TERM_DEBT", column_index),
      CURRENT_PORTION_OF_LONG_TERM_DEBT: get_cell_float("CURRENT_PORTION_OF_LONG_TERM_DEBT", column_index),
      CURRENT_DEFERRED_REVENUE: get_cell_float("CURRENT_DEFERRED_REVENUE", column_index),
      TOTAL_CURRENT_LIABILITIES: get_cell_float("TOTAL_CURRENT_LIABILITIES", column_index),
      LONG_TERM_DEBT: get_cell_float("LONG_TERM_DEBT", column_index),
      NON_CURRENT_DEFERRED_REVENUE: get_cell_float("NON_CURRENT_DEFERRED_REVENUE", column_index),
      DEFERRED_TAX_LIABILITIES: get_cell_float("DEFERRED_TAX_LIABILITIES", column_index),
      TOTAL_LIABILITIES: get_cell_float("TOTAL_LIABILITIES", column_index),
      COMMON_STOCKS_AND_PAID_IN_CAPITAL: get_cell_float("COMMON_STOCKS_AND_PAID_IN_CAPITAL", column_index),
      RETAINED_EARNINGS: get_cell_float("RETAINED_EARNINGS", column_index),
      ACCUMULATED_OTHER_COMPREHENSIVE_INCOME: get_cell_float("ACCUMULATED_OTHER_COMPREHENSIVE_INCOME", column_index),
      TREASURY_STOCK: get_cell_float("TREASURY_STOCK", column_index),
      MINORITY_INTEREST: get_cell_float("MINORITY_INTEREST", column_index),
      TOTAL_EQUITY: get_cell_float("TOTAL_EQUITY", column_index),
      TOTAL_LIABILITIES_AND_EQUITY: get_cell_float("TOTAL_LIABILITIES_AND_EQUITY", column_index)
    }
  end

  def initialize file, onclick_terms
    @onclick_terms = onclick_terms
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

# file = "./htmls/google_BS.html"
# file = "./htmls/apple_BS.html"
# file = "./htmls/PG_BS.html"
file = "./htmls/coke_BS.html"

onclick_terms_file = YAML.load_file('onclick_terms.yml')
onclick_terms = onclick_terms_file["balance_sheet"]

IS = BalanceSheetScraper.new file, onclick_terms

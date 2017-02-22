class BalanceSheetScraper < ParserAndScraper

  def get_date_divs
    query = "//body//tr//th[@class='th']"
    @date_divs = @doc_to_scrape.xpath(query)
  end

  def create_yearly_results_hash date, column_index
    {
      # bs_id: 1,
      year: get_year_integer(date),
      date: date,
      # unit: is_millions?(get_units),
      unit: get_and_set_unit,
      cce: get_cell_float("CCE", column_index),
      marketable_securities: get_cell_float("MARKETABLE_SECURITIES", column_index),
      short_term_investments: get_cell_float("SHORT_TERM_INVESTMENTS", column_index),
      inventory: get_cell_float("INVENTORY", column_index),
      accounts_recievable: get_cell_float("ACCOUNTS_RECIEVABLE", column_index),
      total_current_assets: get_cell_float("TOTAL_CURRENT_ASSETS", column_index),
      avaiable_for_sale_securities: get_cell_float("AVAIABLE_FOR_SALE_SECURITIES", column_index),
      ppe_net: get_cell_float("PPE_NET", column_index),
      goodwill: get_cell_float("GOODWILL", column_index),
      other_intangible_assets: get_cell_float("OTHER_INTANGIBLE_ASSETS", column_index),
      total_assets: get_cell_float("TOTAL_ASSETS", column_index),
      accounts_payable: get_cell_float("ACCOUNTS_PAYABLE", column_index),
      accrued_expenses: get_cell_float("ACCRUED_EXPENSES", column_index),
      short_term_debt: get_cell_float("SHORT_TERM_DEBT", column_index),
      current_portion_of_long_term_debt: get_cell_float("CURRENT_PORTION_OF_LONG_TERM_DEBT", column_index),
      current_deferred_revenue: get_cell_float("CURRENT_DEFERRED_REVENUE", column_index),
      total_current_liabilities: get_cell_float("TOTAL_CURRENT_LIABILITIES", column_index),
      long_term_debt: get_cell_float("LONG_TERM_DEBT", column_index),
      non_current_deferred_revenue: get_cell_float("NON_CURRENT_DEFERRED_REVENUE", column_index),
      deferred_tax_liabilities: get_cell_float("DEFERRED_TAX_LIABILITIES", column_index),
      total_liabilities: get_cell_float("TOTAL_LIABILITIES", column_index),
      common_stocks_and_paid_in_capital: get_cell_float("COMMON_STOCKS_AND_PAID_IN_CAPITAL", column_index),
      retained_earnings: get_cell_float("RETAINED_EARNINGS", column_index),
      accumulated_other_comprehensive_income: get_cell_float("ACCUMULATED_OTHER_COMPREHENSIVE_INCOME", column_index),
      treasury_stock: get_cell_float("TREASURY_STOCK", column_index),
      minority_interest: get_cell_float("MINORITY_INTEREST", column_index),
      total_equity: get_cell_float("TOTAL_EQUITY", column_index),
      total_liabilities_and_equity: get_cell_float("TOTAL_LIABILITIES_AND_EQUITY", column_index)
    }
  end

  def initialize file, onclick_terms
    @onclick_terms = onclick_terms
    parse_file file
    initialize_data_array
    get_date_divs
    get_date_strings
    get_document_period_end_date
    populate_data_array_with_cells
  end

end

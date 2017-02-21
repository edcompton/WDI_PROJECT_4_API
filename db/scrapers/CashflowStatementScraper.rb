class CashflowStatementScraper < ParserAndScraper

  def get_date_divs
    query = "//body//tr//th[@class='th']"
    @date_divs = @doc_to_scrape.xpath(query)[1..-1]
  end

  def create_yearly_results_hash date, column_index
    {
      # CF_id: 1,
      year: get_year_integer(date),
      date: date,
      unit: get_units,
      net_income: get_cell_float("NET_INCOME", column_index),
      d_and_a: get_cell_float("D_AND_A", column_index),
      amortisation: get_cell_float("AMORTISATION", column_index),
      share_compensation: get_cell_float("SHARE_COMPENSATION", column_index),
      deferred_tax: get_cell_float("DEFERRED_TAX", column_index),
      change_in_op_assets_and_liabilities: get_cell_float("CHANGE_IN_OP_ASSETS_AND_LIABILITIES", column_index),
      inventories: get_cell_float("INVENTORIES", column_index),
      receivables: get_cell_float("RECEIVABLES", column_index),
      payables: get_cell_float("PAYABLES", column_index),
      net_cash_from_operating_activities: get_cell_float("NET_CASH_FROM_OPERATING_ACTIVITIES", column_index),
      capex: get_cell_float("CAPEX", column_index),
      disposal_of_ppe: get_cell_float("DISPOSAL_OF_PPE", column_index),
      purchases_of_marketable_securities: get_cell_float("PURCHASES_OF_MARKETABLE_SECURITIES", column_index),
      proceeds_from_sales_of_marketable_securities: get_cell_float("PROCEEDS_FROM_SALES_OF_MARKETABLE_SECURITIES", column_index),
      proceeds_from_maturities_of_marketable_securities: get_cell_float("PROCEEDS_FROM_MATURITIES_OF_MARKETABLE_SECURITIES", column_index),
      acquisitions: get_cell_float("ACQUISITIONS", column_index),
      disposals: get_cell_float("DISPOSALS", column_index),
      net_cash_used_in_investing_activities: get_cell_float("NET_CASH_USED_IN_INVESTING_ACTIVITIES", column_index),
      issuance_of_stock: get_cell_float("ISSUANCE_OF_STOCK", column_index),
      total_debt_issued: get_cell_float("TOTAL_DEBT_ISSUED", column_index),
      total_debt_repayments: get_cell_float("TOTAL_DEBT_REPAYMENTS", column_index),
      long_term_debt_raised: get_cell_float("LONG_TERM_DEBT_RAISED", column_index),
      long_term_debt_repayments: get_cell_float("LONG_TERM_DEBT_REPAYMENTS", column_index),
      net_short_term_debt_issued: get_cell_float("NET_SHORT_TERM_DEBT_ISSUED", column_index),
      payment_of_dividends: get_cell_float("PAYMENT_OF_DIVIDENDS", column_index),
      stock_repurchases: get_cell_float("STOCK_REPURCHASES", column_index),
      net_cash_from_financing_activities: get_cell_float("NET_CASH_FROM_FINANCING_ACTIVITIES", column_index),
      effect_of_fx_on_cash_and_cash_equicalents: get_cell_float("EFFECT_OF_FX_ON_CASH_AND_CASH_EQUICALENTS", column_index),
      net_change_in_cash: get_cell_float("NET_CHANGE_IN_CASH", column_index)
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

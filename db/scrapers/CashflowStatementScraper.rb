class CashflowStatementScraper < ParserAndScraper

  def get_date_divs
    query = "//body//tr//th[@class='th']"
    @date_divs = @doc_to_scrape.xpath(query)[1..-1]
  end

  def create_yearly_results_hash date, column_index
    {
      CF_id: 1,
      year: get_year_integer(date),
      date: date,
      UNIT: get_units,
      NET_INCOME: get_cell_float("NET_INCOME", column_index),
      D_AND_A: get_cell_float("D_AND_A", column_index),
      AMORTISATION: get_cell_float("AMORTISATION", column_index),
      SHARE_COMPENSATION: get_cell_float("SHARE_COMPENSATION", column_index),
      DEFERRED_TAX: get_cell_float("DEFERRED_TAX", column_index),
      CHANGE_IN_OP_ASSETS_AND_LIABILITIES: get_cell_float("CHANGE_IN_OP_ASSETS_AND_LIABILITIES", column_index),
      INVENTORIES: get_cell_float("INVENTORIES", column_index),
      RECEIVABLES: get_cell_float("RECEIVABLES", column_index),
      PAYABLES: get_cell_float("PAYABLES", column_index),
      NET_CASH_FROM_OPERATING_ACTIVITIES: get_cell_float("NET_CASH_FROM_OPERATING_ACTIVITIES", column_index),
      CAPEX: get_cell_float("CAPEX", column_index),
      DISPOSAL_OF_PPE: get_cell_float("DISPOSAL_OF_PPE", column_index),
      PURCHASES_OF_MARKETABLE_SECURITIES: get_cell_float("PURCHASES_OF_MARKETABLE_SECURITIES", column_index),
      PROCEEDS_FROM_SALES_OF_MARKETABLE_SECURITIES: get_cell_float("PROCEEDS_FROM_SALES_OF_MARKETABLE_SECURITIES", column_index),
      PROCEEDS_FROM_MATURITIES_OF_MARKETABLE_SECURITIES: get_cell_float("PROCEEDS_FROM_MATURITIES_OF_MARKETABLE_SECURITIES", column_index),
      ACQUISITIONS: get_cell_float("ACQUISITIONS", column_index),
      DISPOSALS: get_cell_float("DISPOSALS", column_index),
      NET_CASH_USED_IN_INVESTING_ACTIVITIES: get_cell_float("NET_CASH_USED_IN_INVESTING_ACTIVITIES", column_index),
      ISSUANCE_OF_STOCK: get_cell_float("ISSUANCE_OF_STOCK", column_index),
      TOTAL_DEBT_ISSUED: get_cell_float("TOTAL_DEBT_ISSUED", column_index),
      TOTAL_DEBT_REPAYMENTS: get_cell_float("TOTAL_DEBT_REPAYMENTS", column_index),
      LONG_TERM_DEBT_RAISED: get_cell_float("LONG_TERM_DEBT_RAISED", column_index),
      LONG_TERM_DEBT_REPAYMENTS: get_cell_float("LONG_TERM_DEBT_REPAYMENTS", column_index),
      NET_SHORT_TERM_DEBT_ISSUED: get_cell_float("NET_SHORT_TERM_DEBT_ISSUED", column_index),
      PAYMENT_OF_DIVIDENDS: get_cell_float("PAYMENT_OF_DIVIDENDS", column_index),
      STOCK_REPURCHASES: get_cell_float("STOCK_REPURCHASES", column_index),
      NET_CASH_FROM_FINANCING_ACTIVITIES: get_cell_float("NET_CASH_FROM_FINANCING_ACTIVITIES", column_index),
      EFFECT_OF_FX_ON_CASH_AND_CASH_EQUICALENTS: get_cell_float("EFFECT_OF_FX_ON_CASH_AND_CASH_EQUICALENTS", column_index),
      NET_CHANGE_IN_CASH: get_cell_float("NET_CHANGE_IN_CASH", column_index)
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
    Pry::ColorPrinter.pp(@data)
  end
end

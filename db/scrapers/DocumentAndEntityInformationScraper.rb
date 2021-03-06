class DocumentAndEntityInformationScraper < ParserAndScraper

  # Unique dei variations on main class. The monetary units/share units etc are more varied on the dei, so the logic is here to avoid polluting the main ParserAndScraper class.
  def get_main_date_div_dei
    query = "//body//tr/th[@class = 'th'][1][1]"
    @date_divs = get_nokogiri_objects(query)[1..-1]
  end

  def get_monetary_units_dei
    query = "//strong"
    text = get_nokogiri_objects(query)[0].text
    if text.include?(',')
      text.split(',')[1]
    elsif text.include?('(')
      text.split('(')[1].gsub(/\)/, "")
    else
      text.split(')')[1]
    end
  end

  def get_share_units_dei
    query = "//strong"
    text = get_nokogiri_objects(query).text.split('-')
    p text
  end

  def get_document_period_end_date_dei
    query = "//a[contains(@onclick, 'DocumentPeriodEndDate')]/../..//td[@class='text']"
    @document_period_end_date = get_nokogiri_objects(query).text.gsub(/\n/, "")
  end

  def create_yearly_results_hash date, index
    {
      # dei_id: 1,
      year: get_year_integer(date),
      monetary_units: is_millions?(get_monetary_units_dei),
      document_type: get_string_info("DOCUMENT_TYPE", 1),
      amendment_flag: get_boolean_info("AMENDMENT_FLAG", 1),
      document_period_end_date: @document_period_end_date,
      document_fiscal_year_focus: get_int_info("DOCUMENT_FISCAL_YEAR_FOCUS", 1),
      document_fiscal_period_focus: get_string_info("DOCUMENT_FISCAL_PERIOD_FOCUS", 1),
      trading_symbol: get_string_info("TRADING_SYMBOL", 1),
      entity_registrant_name: get_string_info("ENTITY_REGISTRANT_NAME", 1),
      entity_central_index_key: get_int_info("ENTITY_CENTRAL_INDEX_KEY", 1),
      current_fiscal_year_end_date: get_string_info("CURRENT_FISCAL_YEAR_END_DATE", 1),
      entity_well_known_seasoned_issuer: get_boolean_info("ENTITY_WELL_KNOWN_SEASONED_ISSUER", 1),
      entity_current_reporting_status: get_boolean_info("ENTITY_CURRENT_REPORTING_STATUS", 1),
      entity_voluntary_filers: get_boolean_info("ENTITY_VOLUNTARY_FILERS", 1),
      entity_filer_category: get_string_info("ENTITY_FILER_CATEGORY", 1),
      # entity_common_stock_shares_outstanding: get_float_info("ENTITY_COMMON_STOCK_SHARES_OUTSTANDING", 2),
      entity_public_float: get_float_info("ENTITY_PUBLIC_FLOAT", 3)
    }
  end

  def get_string_info key_symbol, column_index
    @onclick_terms[key_symbol].each do |title_phrase|
      query='//a[contains(@onclick, "' + title_phrase + '")]/../../td[2]'
      object = get_nokogiri_objects(query)
      next unless object
      if key_symbol == "CURRENT_FISCAL_YEAR_END_DATE"
        return nokogiri_object_to_date object
      else return nokogiri_object_to_text object
      end
    end
  end

  def initialize file, onclick_terms
    @onclick_terms = onclick_terms
    parse_file file
    initialize_data_array
    get_main_date_div_dei
    get_date_strings
    get_document_period_end_date_dei
    populate_data_array_with_cells
  end
end

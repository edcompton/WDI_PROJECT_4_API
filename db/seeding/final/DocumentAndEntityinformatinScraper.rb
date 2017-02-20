require 'nokogiri'
require 'pp'
require 'pry'
require 'yaml'
load 'ParserAndScraper.rb'

class DocumentAndEntityInformationScraper < ParserAndScraper

  def get_main_date_div_dei
    query = "//body//tr/th[@class = 'th'][1][1]"
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
    query = "//strong//br"
    text = get_nokogiri_objects(query).text
    p text
  end

  def get_document_period_end_date_dei
    query = "//a[contains(@onclick, 'DocumentPeriodEndDate')]/../..//td[@class='text']"
    @document_period_end_date = get_nokogiri_objects(query).text.gsub(/\n/, "")
  end

  def populate_data_array_with_cells
    @date_strings.each_with_index do |date, index|
      p @date
      @data[index] = create_yearly_results_hash date, index
    end
  end

  def create_yearly_results_hash date, index
    {
      DEI_id: 1,
      year: get_year_integer(date),
      SHARE_UNITS: get_share_units_dei,
      MONETARY_UNITS: get_monetary_units_dei,
      DOCUMENT_TYPE: get_string_info("DOCUMENT_TYPE", 1),
      AMENDMENT_FLAG: get_boolean_info("AMENDMENT_FLAG", 1),
      DOCUMENT_PERIOD_END_DATE: @document_period_end_date,
      DOCUMENT_FISCAL_YEAR_FOCUS: get_int_info("DOCUMENT_FISCAL_YEAR_FOCUS", 1),
      DOCUMENT_FISCAL_PERIOD_FOCUS: get_string_info("DOCUMENT_FISCAL_PERIOD_FOCUS", 1),
      TRADING_SYMBOL: get_string_info("TRADING_SYMBOL", 1),
      ENTITY_REGISTRANT_NAME: get_string_info("ENTITY_REGISTRANT_NAME", 1),
      ENTITY_CENTRAL_INDEX_KEY: get_int_info("ENTITY_CENTRAL_INDEX_KEY", 1),
      CURRENT_FISCAL_YEAR_END_DATE: get_string_info("CURRENT_FISCAL_YEAR_END_DATE", 1),
      ENTITY_WELL_KNOWN_SEASONED_ISSUER: get_boolean_info("ENTITY_WELL_KNOWN_SEASONED_ISSUER", 1),
      ENTITY_CURRENT_REPORTING_STATUS: get_boolean_info("ENTITY_CURRENT_REPORTING_STATUS", 1),
      ENTITY_VOLUNTARY_FILERS: get_boolean_info("ENTITY_VOLUNTARY_FILERS", 1),
      ENTITY_FILER_CATEGORY: get_string_info("ENTITY_FILER_CATEGORY", 1),
      ENTITY_COMMON_STOCK_SHARES_OUTSTANDING: get_int_info("ENTITY_COMMON_STOCK_SHARES_OUTSTANDING", 2),
      ENTITY_PUBLIC_FLOAT: get_int_info("ENTITY_PUBLIC_FLOAT", 3)
    }
  end

  def get_string_info key_symbol, column_index
    @onclick_terms[key_symbol].each do |title_phrase|
      query='//a[contains(@onclick, "' + title_phrase + '")]/../../td[2]'
      object = get_nokogiri_objects(query)
      next unless object
      # is_date? key_symbol, object
      if key_symbol == "CURRENT_FISCAL_YEAR_END_DATE"
        return nokogiri_object_to_date object
      end
      return nokogiri_object_to_text object
    end
  end

# Trying to split date checker into another function- needs fix. Possibly room for a general exception checker function if edge cases demand it.
  def is_date? key_symbol, object
    if key_symbol == "CURRENT_FISCAL_YEAR_END_DATE"
      return nokogiri_object_to_date object
    end
  end

  def get_boolean_info key_symbol, column_index
    @onclick_terms[key_symbol].each do |title_phrase|
      query='//a[contains(@onclick, "' + title_phrase + '")]/../../td[2]'
      object = get_nokogiri_objects(query)
      next unless object
      return nokogiri_object_to_bool object
    end
  end

  def get_float_info key_symbol, column_index
    @onclick_terms[key_symbol].each do |title_phrase|
      if column_index == 2 || column_index == 3
        query='//a[contains(@onclick, "' + title_phrase + '")]/../../td[@class ="nump"]'
      else
        query='//a[contains(@onclick, "' + title_phrase + '")]/../../td[2]'
      end
      object = get_nokogiri_objects(query)
      next unless object
      return nokogiri_object_to_float object
    end
  end

  def get_int_info key_symbol, column_index
    @onclick_terms[key_symbol].each do |title_phrase|
      if column_index == 2 || column_index == 3
        query='//a[contains(@onclick, "' + title_phrase + '")]/../../td[@class ="nump"]'
      else query='//a[contains(@onclick, "' + title_phrase + '")]/../../td[2]'
      end
      object = get_nokogiri_objects(query)
      next unless object
      return nokogiri_object_to_int object
    end
  end

  def method_name

  end

  def initialize file, onclick_terms
    @onclick_terms = onclick_terms
    open_file file
    parse_file
    initialize_data_array
    get_main_date_div_dei
    get_date_strings
    get_document_period_end_date_dei
    populate_data_array_with_cells
    Pry::ColorPrinter.pp(@data)
  end

end

onclick_terms_file = YAML.load_file('onclick_terms.yml')
onclick_terms = onclick_terms_file["cover_sheet"]
file = "/Users/jackfuller/development/WDI_PROJECT_4_API/ed_compton/scraping/scraped_files/AAPL/2016/Entity\ Information.html"
file2 = "/Users/jackfuller/development/WDI_PROJECT_4_API/ed_compton/scraping/scraped_files/AAPL/2014/Entity\ Information.html"
file3 = "/Users/jackfuller/development/WDI_PROJECT_4_API/ed_compton/scraping/scraped_files/AAPL/2015/Entity\ Information.html"
file4 = "/Users/jackfuller/development/WDI_PROJECT_4_API/ed_compton/scraping/scraped_files/AAPL/2013/Entity\ Information.html"

p "APPL 2016 ENTITY INFORMATION"
DI = DocumentAndEntityInformationScraper.new file, onclick_terms
p "APPL 2015 ENTITY INFORMATION"
DI2 = DocumentAndEntityInformationScraper.new file3, onclick_terms
p "APPL 2014 ENTITY INFORMATION"
DI3 = DocumentAndEntityInformationScraper.new file2, onclick_terms
p "APPLE 2013 ENTITY INFORMATION"
DI4 = DocumentAndEntityInformationScraper.new file4, onclick_terms

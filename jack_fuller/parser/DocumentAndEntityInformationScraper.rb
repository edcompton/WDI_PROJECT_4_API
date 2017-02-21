require 'nokogiri'
require 'pp'
require 'pry'
require 'yaml'
load 'ParserAndScraper.rb'

class DocumentAndEntityInformationScraper

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

  def get_main_date_div
    query = "//body//tr/th[@class = 'th'][1][1]"
    p @date_divs = get_nokogiri_objects(query)[1..-1]
  end

  def get_date_strings
    @date_strings = @date_divs.collect do |div|
      div.text.gsub(/\n/, "").strip
    end
    p @date_strings
  end

  def get_year_integer date_string
    date_string.gsub(/[^\d]/, '')[-4..-1].to_i
  end

  def get_document_period_end_date
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
      SHARE_UNITS: "",
      MONETARY_UNITS: "",
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
      ENTITY_COMMON_STOCK_SHARES_OUTSTANDING: get_float_info("ENTITY_COMMON_STOCK_SHARES_OUTSTANDING", 2),
      ENTITY_PUBLIC_FLOAT: get_float_info("ENTITY_PUBLIC_FLOAT", 3)
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

# Trying to split date checker into another function- needs fix. Possibly room for a general exception checker function.
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
      else
        query='//a[contains(@onclick, "' + title_phrase + '")]/../../td[2]'
      end
      query='//a[contains(@onclick, "' + title_phrase + '")]/../../td[2]'
      object = get_nokogiri_objects(query)

      next unless object

      return nokogiri_object_to_int object
    end
  end

  def get_cell_info key_symbol, column_index
    @onclick_terms[key_symbol].each do |title_phrase|
      query='//a[contains(@onclick, "' + title_phrase + '")]/../../td[2]'
      object = get_nokogiri_objects(query)
      # if the above returns an object then execute the rest of the method
      next unless object
      return nokogiri_object_to_text object
    end
  end

  def get_appropriate_sign_integer object
    if object.text =~ /\d/
      if negative_number? object
        -(nokogiri_object_to_float(object))
      else
        nokogiri_object_to_float object
      end
    else
      nokogiri_object_to_text object
    end
  end

  def nokogiri_object_to_float nokogiri_object
    return nokogiri_object.text.gsub(/[^\d|.]/, '').to_f
  end

  def nokogiri_object_to_int nokogiri_object
    return nokogiri_object.text.gsub(/[^\d|.]/, '').to_i
  end

  def nokogiri_object_to_bool nokogiri_object
    truthy = ["true", "yes", "Yes"]
    if truthy.include? nokogiri_object.text.gsub(/\n/, "").strip
      return true
    else return false
    end
  end

  def nokogiri_object_to_date nokogiri_object
    return nokogiri_object.text.gsub(/\-/, " ").strip
  end

  def nokogiri_object_to_text nokogiri_object
    return nokogiri_object.text.gsub(/\n/, "").strip
  end

  def negative_number? object
    object.text.include?('(')
  end


  def initialize file, onclick_terms
    @onclick_terms = onclick_terms
    open_file file
    parse_file
    initialize_data_array
    get_main_date_div
    get_date_strings
    get_document_period_end_date
    populate_data_array_with_cells
    Pry::ColorPrinter.pp(@data)
  end

end

onclick_terms_file = YAML.load_file('onclick_terms.yml')
onclick_terms = onclick_terms_file["cover_sheet"]
file = "../scraped_files/AAPL/2016/entity_information.html"

DI = DocumentAndEntityInformationScraper.new file, onclick_terms

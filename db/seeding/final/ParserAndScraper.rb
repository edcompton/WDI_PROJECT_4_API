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

  # def nokogiri_object_to_float nokogiri_object
  #   nokogiri_object.text.gsub(/[^\d|.]/, '').to_i
  # end

  def get_appropriate_sign_integer object
    if negative_number? object
      -(nokogiri_object_to_float(object))
    else
      nokogiri_object_to_float object
    end
  end

  def negative_number? object
    object.text.include?('(')
  end

  def is_millions? unit_string
    if unit_string.include? 'Million'
      @millions = true
    end
    unit_string
  end

  # The cell float function runs on the multi column, number only data sets like balance sheet.
  def get_cell_float key_symbol, column_index
    @onclick_terms[key_symbol].each do |title_phrase|
      query='//a[contains(@onclick, "'+ title_phrase + '")]/../../td[contains(@class, "num")]'
      object = get_nokogiri_objects(query)[column_index]
      # if the above returns an object then execute the rest of the method
      next unless object
      if object
        return get_appropriate_sign_integer object
      else
        return NIL
      end
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

  def nokogiri_object_to_float nokogiri_object
    if (@millions)
      return ((nokogiri_object.text.gsub(/[^\d|.]/, '').to_f) * 10**6)
    else
      return nokogiri_object.text.gsub(/[^\d|.]/, '').to_f
    end
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

  def get_units
    query = "//strong"
    text = get_nokogiri_objects(query)[0].text
    if text.include?(',')
      text.split(',')[1].strip!
    else
      text.split(')')[1].strip!
    end
  end
end

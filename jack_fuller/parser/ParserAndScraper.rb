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

  def nokogiri_object_to_float nokogiri_object
    nokogiri_object.text.gsub(/[^\d|.]/, '').to_f
  end

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

  def get_cell_float key_symbol, column_index
    @onclick_terms[key_symbol].each do |title_phrase|
      query='//a[contains(@onclick, "'+ title_phrase + '")]/../../td[contains(@class, "num")]'
      object = get_nokogiri_objects(query)[column_index]
      # if the above returns an object then execute the rest of the method
      if object
        return get_appropriate_sign_integer object
      else
        return NIL
      end

      # next unless object
      # return get_appropriate_sign_integer object
    end
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

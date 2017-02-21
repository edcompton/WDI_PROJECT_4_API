# Using an array of company tickers
# Query each of the company's 10-k listed statements
# and access each of the consolidated financial statements


# Create a folder directory for that ticker item
# Create a folder directory for that year
# Create 4 files within each for each of meta data, income statement, cash flow
# Append content gathered from the scraper into the created files

require 'nokogiri'
require 'open-uri'
require 'pry'
require 'fileutils'

class SheetSelector

  SEC_URL   = "https://www.sec.gov/cgi-bin/browse-edgar"
  R_NUMBERS = (1..9)

  attr_reader :ticker, :doc
  attr_accessor :sheet_urls, :r_statement

# 'AAPL', 'GOOG', 'KO', 'MMM', 'AXP', 'BA', 'CAT', 'CVX', 'CSCO', 'DIS', 'DD', 'XOM',

  def initialize
    @sheet_urls           = []
    @ticker               = ['GE', 'GS', 'HD', 'IBM', 'INTC', 'JNJ', 'JPM', 'MCD', 'MRK', 'MSFT', 'NKE', 'PFE', 'PG', 'TRV', 'UTX', 'UNH', 'VZ', 'V', 'WMT']
    @ticker.each do |tick|
      @tick = tick
      run
      @sheet_urls         = []
      p @sheet_urls
    end
  end

  def run
    create_ticker_folder
    update_filing_urls_with_r_number
    cycle_urls
  end

  def generate_url_for_query
    "#{SEC_URL}?CIK=#{@tick}&Find=Search&owner=exclude&action=getcompany&output=atom&type=10-k"
  end

  def doc
    @doc = Nokogiri::XML(open(generate_url_for_query))
  end

  def update_filing_urls_with_r_number
    puts generate_url_for_query
    puts @tick
    doc.css('filing-href').each do |url|
      R_NUMBERS.each do |i|
        if !(change_to_https(url).split('/')[-1].include? 'l')
        @sheet_urls << add_r_number(url, i)
        end
      end
    end
    p @sheet_urls
  end

  def create_ticker_folder
    dirname = "ed_compton/scraping/scraped_files/#{@tick}"
    unless File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
    end
  end

  def add_r_number url, i
      (change_to_https(url).split('/')[0..-2] << "R#{i}.htm").join('/')
  end

  def change_to_https url
    url.text.gsub!("http", "https")
  end

  def cycle_urls
    @sheet_urls.each do |sheet_url|
      begin
        @session_id = sheet_url.split('/')[7]
        r_statement = Nokogiri::XML(open(sheet_url))
        find_entity_information(r_statement, @session_id)
        find_balance_sheets(r_statement, @session_id)
        find_cash_flow(r_statement, @session_id)
        find_income_statements(r_statement, @session_id)
        sleep 2
      rescue OpenURI::HTTPError
        next
      end
    end
  end

  def find_entity_information r_statement, session_id
    statement_title = r_statement.css("th[class=tl]").text.to_s.downcase
    if statement_title.include? "document and entity information"
      year_selector = r_statement.css("th[class=th]").text.split(', ').map(&:to_i)
      p year_selector
      @statement_year = year_selector[1]
      title = "#{@tick}_#{@statement_year}_#{session_id}_DEI"
      create_folder_year
      create_file(statement_title, r_statement, title)
    end
  end

  def find_balance_sheets r_statement, session_id
    statement_title = r_statement.css("th[class=tl]").text.to_s.downcase
    if statement_title.include? "balance"
      if !(statement_title.include? "parenthetical")
        year_selector = r_statement.css("th[class=th]").text.split(', ').map(&:to_i)
        p year_selector
        @statement_year = year_selector.max
        title = "#{@tick}_#{@statement_year}_#{session_id}_BS"
        create_folder_year
        create_file(statement_title, r_statement, title)
      end
    end
  end

  def find_income_statements r_statement, session_id
    statement_title = r_statement.css("th[class=tl]").text.to_s.downcase
    if statement_title.include? "income" or statement_title.include? "earnings" or statement_title.include? "operations"
      if !(statement_title.include? "parenthetical") and !(statement_title.include? "equity")
        year_selector = r_statement.css("th[class=th]").text.split(', ').map(&:to_i)
        p year_selector
        @statement_year = year_selector.max
        title = "#{@tick}_#{@statement_year}_#{session_id}_IS"
        create_folder_year
        create_file(statement_title, r_statement, title)
      end
    end
  end

  def find_cash_flow r_statement, session_id
    if r_statement != nil
      statement_title = r_statement.css("th[class=tl]").text.to_s.downcase
      if statement_title.include? "cash"
        year_selector = r_statement.css("th[class=th]").text.split(', ').map(&:to_i)
        p year_selector
        @statement_year = year_selector.max
        title = "#{@tick}_#{@statement_year}_#{session_id}_CF"
        create_folder_year
        create_file(statement_title, r_statement, title)
      end
    end
  end

  def create_folder_year
    dirname = "ed_compton/scraping/scraped_files/#{@tick}/#{@statement_year}"
    unless File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
    end
  end

  def create_file statement_title, r_statement, title
    blank_file = File.new("ed_compton/scraping/scraped_files/#{@tick}/#{@statement_year}/#{title}.html", "w+")
    blank_file.puts (r_statement)
  end
end


SheetSelector.new

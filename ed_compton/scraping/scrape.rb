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
  attr_accessor :sheet_urls, :statements

  def initialize ticker
    @ticker               = ticker
    @sheet_urls           = []
    run
  end

  def run
    create_ticker_folder
    update_filing_urls_with_r_number
    find_entity_information
    find_balance_sheets
    find_income_statements
    find_cash_flow
  end

  def generate_url_for_query
    "#{SEC_URL}?CIK=#{ticker}&Find=Search&owner=exclude&action=getcompany&output=atom&type=10-k"
  end

  def doc
    @doc ||= Nokogiri::XML(open(generate_url_for_query))
  end

  def update_filing_urls_with_r_number
    doc.css('filing-href').each do |url|
      R_NUMBERS.each do |i|
        sheet_urls << add_r_number(url, i)
      end
    end
    puts sheet_urls
  end

  def create_ticker_folder
    dirname = "ed_compton/scraping/scraped_files/#{@ticker}"
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


  def find_entity_information
    sheet_urls.each do |sheet_url|
      begin
        r_statement = Nokogiri::XML(open(sheet_url))
        statement_title = r_statement.css("th[class=tl]").text.to_s
        if statement_title.include? "Entity Information"
          @statement_year = r_statement.xpath("//body//tr//th[@class='th']")[3].text.to_s[-4..-1]
          create_folder_year
          create_file(statement_title, r_statement)
        end
        sleep 2
      rescue OpenURI::HTTPError
        next
      end
    end
  end

  def find_balance_sheets
    sheet_urls.each do |sheet_url|
      begin
        r_statement = Nokogiri::XML(open(sheet_url))
        statement_title = r_statement.css("th[class=tl]").text.to_s
        if statement_title.include? "BALANCE"
          @statement_year = r_statement.css("th[class=th]")[0].text.to_s[-4..-1]
          create_folder_year
          create_file(statement_title, r_statement)
        end
        sleep 2
      rescue OpenURI::HTTPError
        next
      end
    end
  end

  def find_income_statements
    sheet_urls.each do |sheet_url|
      begin
        r_statement = Nokogiri::XML(open(sheet_url))
        statement_title = r_statement.css("th[class=tl]").text.to_s
        # if statement_title.exclude? "Parenthetical"
        if statement_title.include? "INCOME" or statement_title.include? "EARNINGS" or statement_title.include? "OPERATIONS"
          @statement_year = r_statement.css("th[class=th]")[1].text.to_s[-4..-1]
          create_folder_year
          create_file(statement_title, r_statement)
        end
        # end
        sleep 2
      rescue OpenURI::HTTPError
        next
      end
    end
  end

  def find_cash_flow
    sheet_urls.each do |sheet_url|
      begin
        r_statement = Nokogiri::XML(open(sheet_url))
        if r_statement != nil
          statement_title = r_statement.css("th[class=tl]").text.to_s
          if statement_title.include? "CASH"
            @statement_year = r_statement.xpath("//body//tr//th[@class='th']")[1].text.to_s[-4..-1]
            puts @statement_year
            create_folder_year
            create_file(statement_title, r_statement)
          end
        end
        sleep 2
      rescue OpenURI::HTTPError
        next
      end
    end
  end

  def create_folder_year
    dirname = "ed_compton/scraping/scraped_files/#{@ticker}/#{@statement_year}"
    unless File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
    end
  end

  def create_file statement_title, r_statement
    blank_file = File.new("ed_compton/scraping/scraped_files/#{@ticker}/#{@statement_year}/#{statement_title}.html", "w+")
    blank_file.puts (r_statement)
  end
end


SheetSelector.new "GOOG"

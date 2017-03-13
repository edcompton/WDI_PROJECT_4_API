# where should these be required?
# can go in lib
# should become tasks
require 'nokogiri'
require 'pp'
require 'pry'
require 'yaml'

require_relative './scrapers/FileNavigator'
require_relative './scrapers/ParserAndScraper'
require_relative './scrapers/BalanceSheetScraper'
require_relative './scrapers/CashflowStatementScraper'
require_relative './scrapers/DocumentAndEntityInformationScraper'
require_relative './scrapers/IncomeStatementScraper'

# p Dir["ed_compton/scraping/scraped_files/AAPL/2016/*"]
# p Dir["ed_compton/scraping/scraped_files/*/*"]

# filing_year_directories = ["ed_compton/scraping/scraped_files/AAPL/2016"]
filing_year_directories = Dir["ed_compton/scraping/scraped_files/*/*"]

class Seeder

  def save_company_filing_and_docs
    @company.save
    p @filing
    @company.filings << @filing
    @filing.dei_statement = @dei
    @filing.bs_yearly_results << @bs_yearly_results
    @filing.cf_yearly_results << @cf_yearly_results
    @filing.is_yearly_results << @is_yearly_results
  end

  def print_company_filing_and_docs
    p @company
    p @filing
    p @dei.filing_id
    p @bs_yearly_results[0].filing_id
    p @cf_yearly_results[0].filing_id
    p @is_yearly_results[0].filing_id
  end

  def get_onclick_terms_file
    YAML.load_file(File.open('db/scrapers/onclick_terms.yml'))
  end

  def parse_bs
    onclick_terms = @onclick_terms_file["balance_sheet"]
    bs_yearly_results = BalanceSheetScraper.new @file, onclick_terms
    @bs_yearly_results = bs_yearly_results.return_data
    @bs_yearly_results.collect! do |bs_yearly_result|
      BsYearlyResult.new(bs_yearly_result)
    end
  end

  def parse_cf
    onclick_terms = @onclick_terms_file["cashflow_statement"]
    cf_yearly_results = CashflowStatementScraper.new @file, onclick_terms
    @cf_yearly_results = cf_yearly_results.return_data
    @cf_yearly_results.collect! do |cf_yearly_result|
      CfYearlyResult.new(cf_yearly_result)
    end
  end

  def parse_dei
    onclick_terms = @onclick_terms_file["cover_sheet"]
    dei = DocumentAndEntityInformationScraper.new @file, onclick_terms
    @dei = DeiStatement.new(dei.return_data[0])
  end

  def parse_is
    onclick_terms = @onclick_terms_file["income_statement"]
    is_yearly_results = IncomeStatementScraper.new @file, onclick_terms
    @is_yearly_results = is_yearly_results.return_data
    @is_yearly_results.collect! do |is_yearly_result|
      IsYearlyResult.new(is_yearly_result)
    end
  end

  def test_type_and_parse type
    case type
      when 'BS'
        parse_bs
      when 'CF'
        parse_cf
      when 'DEI'
        parse_dei
      when 'IS'
        parse_is
    end
  end

  def parse_file
    details = @file_path.split('/')[-1].split('_')
    type = details[-1].split('.')[0]
    test_type_and_parse type
  end

  def filing_already_saved? year
    !!@company.filings.find_by({year: year})
  end

  def set_file_and_parse file_path
    puts "file path: #{file_path}"
    @file_path = file_path
    @file = File.open @file_path
    parse_file
  end

  def new_filing year, accession_id
    Filing.new({
      year: year,
      accession_id: accession_id
    })
  end

  def new_company ticker
    url = "https://query2.finance.yahoo.com/v10/finance/quoteSummary/#{ticker}?formatted=true&crumb=aiUUOqOuMGO&lang=en-US&region=US&modules=description%2CsummaryProfile&corsDomain=finance.yahoo.com"
    response = HTTParty.get(url)
    x = response.parsed_response

    tickerHash = {}

    tickerHash['ticker'] = "#{ticker}"
    tickerHash['description'] = x['quoteSummary']['result'][0]['description']['shortBusinessSummary']
    tickerHash['sector'] = x['quoteSummary']['result'][0]['summaryProfile']['sector']

    Company.new(tickerHash)
  end

  def get_company ticker
    Company.find_by({ticker: ticker}) || new_company(ticker)
  end

  def set_details filing_year_directory
    @file_paths = Dir["#{filing_year_directory}/*"]
    details = @file_paths[0].split('/')[-1].split('_')
    @ticker = details[0]
    @year = details[1]
    @accession_id = details[2]
  end

  def set_comp_and_filing
    @company = get_company @ticker
    return if filing_already_saved? @year
    @filing = new_filing(@year, @accession_id)
  end

  def set_files_and_parse
    @file_paths.each {|file_path| set_file_and_parse file_path }
  end

  def set_comp_name
    @company.name = @company.name || @dei.entity_registrant_name
  end

  def initialize filing_year_directories
    @onclick_terms_file = get_onclick_terms_file
    filing_year_directories.each do |filing_year_directory|
      p filing_year_directory
      set_details filing_year_directory
      set_comp_and_filing
      # next if !@filing
      set_files_and_parse
      set_comp_name
      save_company_filing_and_docs
      # print_company_filing_and_docs
    end
  end

end

Seeder.new filing_year_directories

# challenges: requireing classes, accessing modules, loading files (relative vs load), error handling, data is never consistent
# wins: seeing the seed file tick over, overcoming some of the above
# learning: classes, small methods, one input, one output, makes debugging a lot easier.  bloated code is horrible, always stay focused on keeping it light a modular, future self will thank you, happy coding instead of angry coding.

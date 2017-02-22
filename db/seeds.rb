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
require_relative './Seeder'

# onclick_terms_file = YAML.load_file(File.open('./scrapers/onclick_terms.yml'))

directory_path = 'ed_compton/scraping/scraped_files/'
file_path1 = directory_path + 'AAPL/2016/AAPL_2016_000162828016020309_BS.html'
file_path2 = directory_path + 'AAPL/2016/AAPL_2016_000162828016020309_CF.html'
file_path3 = directory_path + 'AAPL/2016/AAPL_2016_000162828016020309_DEI.html'
file_path4 = directory_path + 'AAPL/2016/AAPL_2016_000162828016020309_IS.html'
file_paths = [file_path1, file_path2, file_path3, file_path4]
# yaml_file_path = 'db/scrapers/onclick_terms.yml'
# File.open(yaml_file_path)

# p Dir["ed_compton/scraping/scraped_files/AAPL/2016/*"]
# p Dir["ed_compton/scraping/scraped_files/*/*"]

filing_year_directories = ["ed_compton/scraping/scraped_files/AAPL/2016"]

class Seeder

  def save_company_filing_and_docs
    @company.save
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

  def print_bs
    onclick_terms = @onclick_terms_file["balance_sheet"]
    bs_yearly_results = BalanceSheetScraper.new @file, onclick_terms
    @bs_yearly_results = bs_yearly_results.return_data
    @bs_yearly_results.collect! do |bs_yearly_result|
      BsYearlyResult.new(bs_yearly_result)
    end
  end

  def print_cf
    onclick_terms = @onclick_terms_file["cashflow_statement"]
    cf_yearly_results = CashflowStatementScraper.new @file, onclick_terms
    @cf_yearly_results = cf_yearly_results.return_data
    @cf_yearly_results.collect! do |cf_yearly_result|
      CfYearlyResult.new(cf_yearly_result)
    end
  end

  def print_dei
    onclick_terms = @onclick_terms_file["cover_sheet"]
    dei = DocumentAndEntityInformationScraper.new @file, onclick_terms
    @dei = DeiStatement.new(dei.return_data[0])
  end

  def print_is
    onclick_terms = @onclick_terms_file["income_statement"]
    is_yearly_results = IncomeStatementScraper.new @file, onclick_terms
    @is_yearly_results = is_yearly_results.return_data
    @is_yearly_results.collect! do |is_yearly_result|
      IsYearlyResult.new(is_yearly_result)
    end
  end

  def test_type_and_print type
    case type
      when 'BS'
        print_bs
      when 'CF'
        print_cf
      when 'DEI'
        print_dei
      when 'IS'
        print_is
    end
  end

  def parse_file
    details = @file_path.split('/')[-1].split('_')
    type = details[-1].split('.')[0]

    test_type_and_print type
  end

  def filing_already_saved? year
    !!@company.filings.find_by({year: year})
  end

  def set_file_and_parse file_path
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
    Company.new({
      ticker: ticker
    })
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

  def get_details_parse_and_save filing_year_directory
    set_details filing_year_directory
    @company = get_company @ticker
    return if filing_already_saved? @year
    @filing = new_filing(@year, @accession_id)
    @file_paths.each {|file_path| set_file_and_parse file_path }
    @company.name = @company.name || @dei.entity_registrant_name
    save_company_filing_and_docs
  end

  def initialize filing_year_directories
    @onclick_terms_file = get_onclick_terms_file
    filing_year_directories.each do |filing_year_directory|
      get_details_parse_and_save filing_year_directory
      print_company_filing_and_docs
    end
  end

end

Seeder.new filing_year_directories



# f1.bs_yearly_results << bs1
# f1.is_yearly_results << is1
# f1.cf_yearly_results << cf1
# f1.dei_statement = dei1
#
# c1.filings << f1
#
# w1.companies << c1

# loop over whats been

# after first 25 put validations in models for required fields

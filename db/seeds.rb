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

class Seeder
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
    @bs_yearly_results.each do |bs_yearly_result|
      Pry::ColorPrinter.pp bs_yearly_result
      @filing.bs_yearly_results << bs_yearly_result
    end
  end

  def print_cf
    onclick_terms = @onclick_terms_file["cashflow_statement"]
    cf_yearly_results = CashflowStatementScraper.new @file, onclick_terms
    @cf_yearly_results = cf_yearly_results.return_data
    @cf_yearly_results.collect! do |cf_yearly_result|
      CfYearlyResult.new(cf_yearly_result)
    end
    @cf_yearly_results.each do |cf_yearly_result|
      Pry::ColorPrinter.pp cf_yearly_result
      @filing.cf_yearly_results << cf_yearly_result
    end
  end

  def print_dei
    onclick_terms = @onclick_terms_file["cover_sheet"]
    dei = DocumentAndEntityInformationScraper.new @file, onclick_terms
    @dei = DeiStatement.new(dei.return_data[0])
    @filing.dei_statement = @dei
    Pry::ColorPrinter.pp @dei
  end

  def print_is
    onclick_terms = @onclick_terms_file["income_statement"]
    is_yearly_results = IncomeStatementScraper.new @file, onclick_terms
    @is_yearly_results = is_yearly_results.return_data
    @is_yearly_results.collect! do |is_yearly_result|
      IsYearlyResult.new(is_yearly_result)
    end
    @is_yearly_results.each do |is_yearly_result|
      Pry::ColorPrinter.pp is_yearly_result
      @filing.is_yearly_results << is_yearly_result
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
    ticker = details[0]
    year = details[1]
    accession_id = details[2]
    type = details[-1].split('.')[0]

    if Company.find_by({ticker: ticker})
      puts 'found company'
      @company = Company.find_by({ticker: ticker})
    else
      puts 'new company'
      puts Company.new({ ticker: ticker })
      @company = Company.new({ ticker: ticker })
      puts @company
    end

    if Filing.find_by({ accession_id: accession_id})
      puts 'found filing'
      @filing = Filing.find_by({ accession_id: accession_id})
      # @filing = false
      # exit
    else
      puts 'new filing'
      @filing = Filing.new({
        accession_id: accession_id,
        year: year
        })
    end

    test_type_and_print type
  end

  def initialize file_paths
    file_paths.each do |file_path|
      @file_path = file_path
      @onclick_terms_file = get_onclick_terms_file
      # @file = File.open(File.join(Rails.root, file_path))
      @file = File.open @file_path
      parse_file
    end
    if @filing
      @company.filings << @filing
      puts @company
      @company.save
    end
  end
end

Seeder.new file_paths



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

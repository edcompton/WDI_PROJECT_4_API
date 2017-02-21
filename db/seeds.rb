# where should these be required?
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

onclick_terms_file = YAML.load_file(File.open('./scrapers/onclick_terms.yml'))

directory_path = './../ed_compton/scraping/scraped_files/'
# file_path = directory_path + 'AAPL/2016/AAPL_2016_000162828016020309_BS.html'
# file_path = directory_path + 'AAPL/2016/AAPL_2016_000162828016020309_CF.html'
# file_path = directory_path + 'AAPL/2016/AAPL_2016_000162828016020309_DEI.html'
file_path = directory_path + 'AAPL/2016/AAPL_2016_000162828016020309_IS.html'
file = File.open file_path

def parse_file file_path, file, onclick_terms_file
  details = file_path.split('/')[-1].split('_')
  ticker = details[0]
  year = details[1]
  accession_id = details[2]
  type = details[-1].split('.')[0]
  case type
    when 'BS'
      onclick_terms = onclick_terms_file["balance_sheet"]
      BalanceSheetScraper.new file, onclick_terms
    when 'CF'
      onclick_terms = onclick_terms_file["cashflow_statement"]
      CashflowStatementScraper.new file, onclick_terms
    when 'DEI'
      onclick_terms = onclick_terms_file["cover_sheet"]
      DocumentAndEntityInformationScraper.new file, onclick_terms
    when 'IS'
      onclick_terms = onclick_terms_file["income_statement"]
      IncomeStatementScraper.new file, onclick_terms
  end
end

parse_file file_path, file, onclick_terms_file

# f1.bs_yearly_results << bs1
# f1.is_yearly_results << is1
# f1.cf_yearly_results << cf1
# f1.dei_statement = dei1
#
# c1.filings << f1
#
# w1.companies << c1

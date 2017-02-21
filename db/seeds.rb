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

directory_path = './../ed_compton/scraping/scraped_files/'
file_path1 = directory_path + 'AAPL/2016/AAPL_2016_000162828016020309_BS.html'
file_path2 = directory_path + 'AAPL/2016/AAPL_2016_000162828016020309_CF.html'
file_path3 = directory_path + 'AAPL/2016/AAPL_2016_000162828016020309_DEI.html'
file_path4 = directory_path + 'AAPL/2016/AAPL_2016_000162828016020309_IS.html'
file_paths = [file_path1, file_path2, file_path3, file_path4]

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

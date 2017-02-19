load 'BalanceSheetScraper.rb'
load 'IncomeStatmentScraper.rb'

class FileNavigator

  Dir.chdir "../scraped_files"
  COMPANY_ROOT_DIRS = Dir.glob "*"
  
  COMPANY_ROOT_DIRS.each do |dir|
    p dir
  end
  def initialize root_dir

  end
end

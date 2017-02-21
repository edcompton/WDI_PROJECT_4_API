# load 'BalanceSheetScraper.rb'
# load 'IncomeStatmentScraper.rb'

class FileNavigator

  def find_files root_dir
    @files = Dir.glob("#{root_dir}/**/*.html")
    loop_through_files @files
  end

  def loop_through_files files
    files.each do |file|
      p file
    end
  end

  def initialize root_dir
    find_files root_dir
  end
end

FileNavigator.new("/Users/jackfuller/development/WDI_PROJECT_4_API/ed_compton/scraping")

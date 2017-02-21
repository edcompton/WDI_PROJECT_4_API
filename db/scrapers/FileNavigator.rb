class FileNavigator

  def find_files root_dir
    @files = Dir.glob("#{root_dir}/**/*.html")
    # loop_through_files @files
  end

  # def loop_through_files files
  #   files.each do |file|
  #     return file
  #   end
  # end

  def initialize root_dir
    find_files root_dir
  end
end
# 
# files = FileNavigator.new("../ed_compton/scraping/scraped_files")
# p files

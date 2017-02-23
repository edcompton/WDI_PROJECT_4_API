require 'nokogiri'
@ticker = 'GOOG'

statement_files = Dir["ed_compton/scraping/scraped_files/#{@ticker}/2016/*"]

statement_files.each do |file|
  if !(file.include? 'DEI.ht')
    @doc = File.open(file) { |f| Nokogiri::XML(f) }
    onclicks = @doc.xpath("//a//@onclick")
    onclicks.each do |item|
      if item.value.include? 'defref'
        p (item.value.split('_')[2].split('\'')[0])
      end
    end
    puts '-----------------------------------------'
  end
end


#
# henry_onclicks = ("/Users/henrydavies/development/WDI_PROJECT_4_API/ed_compton/scraping/scraped_files/#{@ticker}/2016/AAPL_2016_000162828016020309_IS.html")
#
# @doc = File.open(henry_onclicks) { |f| Nokogiri::XML(f) }
#
# onclicks = @doc.xpath("//a//@onclick")
#
# onclicks.each do |item|
#   p (item.value.split('_')[2].split('\'')[0])
# end
#
#
#
# def create_file ticker
#   title = "#{@ticker}.yml"
#   blank_file = File.new("henry_davies/YML_files/#{@ticker}.yml", "w+")
#   blank_file.puts (r_statement)
# end

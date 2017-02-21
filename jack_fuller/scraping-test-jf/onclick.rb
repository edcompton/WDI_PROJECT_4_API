require "nokogiri"
require "pry"
require "pp"

# query="//a[@onclick = '#{@prefix}#{title_phrase}#{@suffix}']"

file = "/Users/jackfuller/development/WDI_PROJECT_4_API/raw_htmls/balance_sheets/apple_BS.html"
doc_to_parse = File.open(file)
doc_to_scrape = Nokogiri::HTML.parse(doc_to_parse)

phrase = "_CashAndCashEquivalentsAtCarryingValue\'"

query='//a[contains(@onclick, "'+ phrase + '")]/../../td[@class="nump"]'



p doc_to_scrape.xpath(query)

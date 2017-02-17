require 'nokogiri'

@onlick_values = ["AssetsCurrentAbstract", "CashAndCashEquivalentsAtCarryingValue",
"AvailableForSaleSecuritiesCurrent",
"AccountsReceivableNetCurrent",
"InventoryNet",
"NontradeReceivablesCurrent",
"OtherAssetsCurrent",
"AssetsCurrent",
"AvailableForSaleSecuritiesNoncurrent",
"PropertyPlantAndEquipmentNet",
"Goodwill",
"IntangibleAssetsNetExcludingGoodwill",
"OtherAssetsNoncurrent",
"Assets",
"LiabilitiesCurrentAbstract",
"AccountsPayableCurrent",
"AccruedLiabilitiesCurrent",
"DeferredRevenueCurrent",
"CommercialPaper",
"LongTermDebtCurrent",
"LiabilitiesCurrent",
"DeferredRevenueNoncurrent",
"LongTermDebtNoncurrent",
"OtherLiabilitiesNoncurrent",
"Liabilities",
"CommitmentsAndContingencies",
"StockholdersEquityAbstract",
"CommonStocksIncludingAdditionalPaidInCapital",
"RetainedEarningsAccumulatedDeficit",
"AccumulatedOtherComprehensiveIncomeLossNetOfTax",
"StockholdersEquity",
"LiabilitiesAndStockholdersEquity"
]

class BalanceSheetParser
  BS = {
    :dates => [

    ]
  }
  # attr_accessor :parsed_document
  #
  # def initialize url
  #   @url = url
  #   parse
  # end
  #
  # def parse
  #   parsed_document = File.open(url) { |f| Nokogiri::XML(f) }
  # end

  @doc_to_parse = File.open("/Users/jackfuller/development/WDI_PROJECT_4_API/raw_htmls/balance_sheets/apple_BS.xml") { |f| Nokogiri::XML(f) }

  # Once a given onclick has been found to contain a relevant node, we can then extract the relvant values.
  def self.find_values xml_node
    value_nodes = xml_node.xpath("./../../../td[@class = 'nump']")
    p value_nodes.text
  end

  def self.find_onclicks
    onclicks = @doc_to_parse.xpath("//a//@onclick")
    onclicks.each do |onclick|
      if onclick.value.include? 'Cash'
        p onclick.value.split(',')[1]
        find_values onclick
      elsif onclick.value.include? "AvailableForSaleSecuritiesCurrent"
        p onclick.value.split(',')[1]
        find_values onclick
      end
    end
  end
  # create the date objects.


  # Finds the earliest year by looking at the available years at the top of the balance sheet. The function currently assumes they're always in the same xpath. Then adds the years to the dates array in the balance sheet object, as well as initialising the date objects which will contain the company data. 
  def self.find_years
    dates = @doc_to_parse.xpath("//body//tr//th[@class='th']")
    dates.each do |i|
      i = number_or_nil i.text.split(',')[1]
      BS[:dates].push(i)
    end
    BS[:dates].sort!
    BS[:dates].each do |date|
      BS["#{date}"] = {}
    end
    p BS
  end

  # Rescues can be updated to account for edge cases - currently returns nil if not strictly parseable as an integer.
  def self.number_or_nil string
    Integer(string || '')
  rescue ArgumentError
    nil
  end

end

BalanceSheetParser.find_years
BalanceSheetParser.find_onclicks

# BS = {
#   dates: [],
#   "2016": {
#     Sales: {
#       on_click_title: "",
#       row_title: "",
#       value: 0
#     },
#     COGS: {
#       on_click_title: "CostOfGoodsAndServicesSold",
#       value: 145000
#     }
#   },
#   "2015": {
#     Sales: {
#       on_click_title: "SalesRevenueNet",
#       value: 215678
#     },
#     COGS: {
#       on_click_title: "CostOfGoodsAndServicesSold",
#       value: 145000
#     }
#   }
# }

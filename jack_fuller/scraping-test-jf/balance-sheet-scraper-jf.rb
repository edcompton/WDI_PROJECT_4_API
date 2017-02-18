require 'nokogiri'
require 'active_support'
require 'active_support/core_ext'

class BalanceSheetParser

  # @onclick_values = ["defref_us-gaap_AssetsCurrentAbstract"], ["defref_us-gaap_CashAndCashEquivalentsAtCarryingValue"],
  # ["defref_us-gaap_AvailableForSaleSecuritiesCurrent"],
  # ["defref_us-gaap_AccountsReceivableNetCurrent"],
  # ["defref_us-gaap_InventoryNet"],
  # ["defref_us-gaap_NontradeReceivablesCurrent"],
  # ["defref_us-gaap_OtherAssetsCurrent"],
  # ["defref_us-gaap_AssetsCurrent"],
  # ["defref_us-gaap_AvailableForSaleSecuritiesNoncurrent"],
  # ["defref_us-gaap_PropertyPlantAndEquipmentNet"],
  # ["defref_us-gaap_Goodwill"],
  # ["defref_us-gaap_IntangibleAssetsNetExcludingGoodwill"],
  # ["defref_us-gaap_OtherAssetsNoncurrent"],
  # ["defref_us-gaap_Assets"],
  # ["defref_us-gaap_LiabilitiesCurrentAbstract"],
  # ["defref_us-gaap_AccountsPayableCurrent"],
  # ["defref_us-gaap_AccruedLiabilitiesCurrent"],
  # ["defref_us-gaap_DeferredRevenueCurrent"],
  # ["defref_us-gaap_CommercialPaper"],
  # ["defref_us-gaap_LongTermDebtCurrent]",
  # ["defref_us-gaap_LiabilitiesCurrent"],
  # ["defref_us-gaap_DeferredRevenueNoncurrent"],
  # ["defref_us-gaap_LongTermDebtNoncurrent"],
  # ["defref_us-gaap_OtherLiabilitiesNoncurrent"],
  # ["defref_us-gaap_Liabilities"],
  # ["defref_us-gaap_CommitmentsAndContingencies"],
  # ["defref_us-gaap_StockholdersEquityAbstract"],
  # ["defref_us-gaap_CommonStocksIncludingAdditionalPaidInCapital"],
  # ["defref_us-gaap_RetainedEarningsAccumulatedDeficit"],
  # ["defref_us-gaap_AccumulatedOtherComprehensiveIncomeLossNetOfTax"],
  # ["defref_us-gaap_StockholdersEquity"],
  # ["defref_us-gaap_LiabilitiesAndStockholdersEquity"]
  # ]
  @onclick_values = ["defref_us-gaap_AssetsCurrentAbstract", "defref_us-gaap_CashAndCashEquivalentsAtCarryingValue",
  "defref_us-gaap_AvailableForSaleSecuritiesCurrent",
  "defref_us-gaap_AccountsReceivableNetCurrent",
  "defref_us-gaap_InventoryNet",
  "defref_us-gaap_NontradeReceivablesCurrent",
  "defref_us-gaap_OtherAssetsCurrent",
  "defref_us-gaap_AssetsCurrent",
  "defref_us-gaap_AvailableForSaleSecuritiesNoncurrent",
  "defref_us-gaap_PropertyPlantAndEquipmentNet",
  "defref_us-gaap_Goodwill",
  "defref_us-gaap_IntangibleAssetsNetExcludingGoodwill",
  "defref_us-gaap_OtherAssetsNoncurrent",
  "defref_us-gaap_Assets",
  "defref_us-gaap_LiabilitiesCurrentAbstract",
  "defref_us-gaap_AccountsPayableCurrent",
  "defref_us-gaap_AccruedLiabilitiesCurrent",
  "defref_us-gaap_DeferredRevenueCurrent",
  "defref_us-gaap_CommercialPaper",
  "defref_us-gaap_LongTermDebtCurrent",
  "defref_us-gaap_LiabilitiesCurrent",
  "defref_us-gaap_DeferredRevenueNoncurrent",
  "defref_us-gaap_LongTermDebtNoncurrent",
  "defref_us-gaap_OtherLiabilitiesNoncurrent",
  "defref_us-gaap_Liabilities",
  "defref_us-gaap_CommitmentsAndContingencies",
  "defref_us-gaap_StockholdersEquityAbstract",
  "defref_us-gaap_CommonStocksIncludingAdditionalPaidInCapital",
  "defref_us-gaap_RetainedEarningsAccumulatedDeficit",
  "defref_us-gaap_AccumulatedOtherComprehensiveIncomeLossNetOfTax",
  "defref_us-gaap_StockholdersEquity",
  "defref_us-gaap_LiabilitiesAndStockholdersEquity"
  ]
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

  # Once a given onclick has been found to contain a relevant node, we can then extract the relvant values. The top one has
  # def self.find_values xml_node
  #   value_nodes = xml_node.xpath("./../../../td[@class = 'nump']")
  #   p value_nodes[0].text.split(' ')[1]
  #
  # end


  # Finds all the onclicks, checks their values against the array of possibilities and finds the values.
  def self.find_onclicks
    onclicks = @doc_to_parse.xpath("//a//@onclick")
    onclicks.each_with_index do |onclick, index|
      if @onclick_values.include? onclick.value.split(',')[1]
        p 'ping'
        # p onclick.value.split(',')[1]
        # find_values onclick
      # elsif onclick.value.include? "AvailableForSaleSecuritiesCurrent"
        # p onclick.value.split(',')[1]
        # find_values onclick
      end
    end
  end

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

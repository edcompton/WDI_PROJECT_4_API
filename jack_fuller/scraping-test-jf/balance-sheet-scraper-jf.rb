require 'nokogiri'

class BalanceSheetParser
  @balance_sheet = {
    company_ticker => '',
    filing_year => 0,
    cash_and_cash_equivalents => 0,
    marketable_securities => 0,
    short_term_investments => 0,
    inventory => 0,
    accounts_recievable => 0,
    available_for_sale_securities => 0,
    property_plant_and_equipment_net => 0,
    goodwill => 0,
    other_intangible_assets => 0,
    total_assets => 0,
    accounts_payable_and_accrued_expenses => 0,
    accounts_payable => 0,
    accrued_expenses => 0,
    short_term_debt => 0,
    current_portion_long_term_debt => 0,
    current_deferred_revenue => 0,
    total_current_liabilities => 0,
    long_term_debt => 0,
    non_current_deferred_revenue => 0,
    deferred_tax_liabilities => 0,
    total_liabilities => 0,
    stock_value => 0,
    preferred_stock => 0,
    additional_paid_in_capital => 0,
    retained_earnings => 0,
    accumulated_other_comprehensive_income => 0,
    treasury_stock => 0,
    minority_interest => 0,
    total_liabilities_and_equity => 0
  }

  attr_accessor :parsed_document

  def initialize url
    @url = url
    parse
  end

  def parse
    parsed_document = File.open(url) { |f| Nokogiri::XML(f) }
  end

  @doc_to_parse = File.open("/Users/jackfuller/development/WDI_PROJECT_4_API/raw_htmls/balance_sheets/apple_BS.xml") { |f| Nokogiri::XML(f) }

  def self.find_onclicks
    onclicks = @doc_to_parse.xpath("//a//@onclick")
    onclicks.each do |onclick|
      if onclick.value.include? cash_cash_equivalents[0]
        p onclick.value.split(',')[1]
        find_and_set_values onclick
      elsif onclick.value.include? "AvailableForSaleSecuritiesCurrent"
        p onclick.value.split(',')[1]
        find_and_set_values onclick
      end
    end
  end

  # Once a given onclick has been found to contain a relevant node, we can then extract the relvant values.
  def self.find_values xml_node
    value_nodes = xml_node.xpath("./../../../td[@class = 'nump']")
    value_nodes
  end

  # Finds the earliest year by looking at the available years at the top of the balance sheet. The function currently assumes they're always in the same xpath.
  def self.find_years
    date_array = []
    dates = @doc_to_parse.xpath("//body//tr//th[@class='th']")
    dates.each do |i|
      i = number_or_nil i.text.split(',')[1]
      date_array.push(i)
      p date_array
    end
  end

  # Rescues can be updated to account for edge cases - currently reutrns nil if not strictly parseable as an integer.
  def self.number_or_nil
    Integer(string || '')
  rescue ArgumentError
    nil
  end

end

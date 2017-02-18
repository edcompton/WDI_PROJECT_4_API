require 'nokogiri'

henry_onclicks = ("/Users/henrydavies/development/WDI_PROJECT_4_API/raw_htmls/cash_flow_statements/google_CF.xml")

@doc = File.open(henry_onclicks) { |f| Nokogiri::XML(f) }

onclicks = @doc.xpath("//a//@onclick")

onclicks.each do |item|
  p item.value.split(',')[1]
end

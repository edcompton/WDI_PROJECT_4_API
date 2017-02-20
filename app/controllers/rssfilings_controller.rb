require 'open-uri'

class RssfilingsController < ApplicationController

  def filing_feed
    tickers = params["_json"]
    filingFeeds = []
    tickers.each_with_index do |ticker, tickerIndex|
      # NEED TO LOOK UP CIK IN DATABASE
      cik = '0000320193'
      url = "https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=#{cik}&type=&dateb=&owner=exclude&start=0&count=40&output=atom"
      # response = HTTParty.get(url)
      # data = response.parsed_response
      doc = open(url)
      parsed = Nokogiri::XML(doc)
      objectArray = []

      titles = parsed.css("entry title")
      titles.each_with_index do |title, index|
          objectArray[index] = { title: title.text }
      end
      links = parsed.css("entry filing-href")
      links.each_with_index do |link, index|
          objectArray[index]['link'] = link.text
      end
      dates = parsed.css("entry updated")
      dates.each_with_index do |date, index|
          objectArray[index]['date'] = date.text
      end

      filingFeeds[tickerIndex] = objectArray
    end
    p filingFeeds
  end
end

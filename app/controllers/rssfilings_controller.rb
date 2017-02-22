require 'open-uri'
require 'Date'

class RssfilingsController < ApplicationController

  def filing_feed
    tickers = params["_json"]
    filingFeeds = []
    tickers.each_with_index do |ticker, tickerIndex|
      # NEED TO LOOK UP CIK IN DATABASE
      # Company.find_by ticker: 'AAPL'
      cik = '0000320193'
      url = "https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=#{cik}&type=&dateb=&owner=exclude&start=0&count=10&output=atom"
      # response = HTTParty.get(url)
      # data = response.parsed_response
      doc = open(url)
      parsed = Nokogiri::XML(doc)

      titles = parsed.css("entry title")
      titles.each_with_index do |title, index|
          filingFeeds << {
            title: title.text,
            ticker: ticker,
            cik: cik,
            link: parsed.css("entry filing-href")[index].text,
            date: Date.parse(parsed.css("entry updated")[index].text)
          }
      end
      # links = parsed.css("entry filing-href")
      # links.each_with_index do |link, index|
      #     objectArray[index]['link'] = link.text
      # end
      # dates = parsed.css("entry updated")
      # dates.each_with_index do |date, index|
      #     objectArray[index]['date'] = date.text
      # end

    end
    sortedFilingFeeds = (filingFeeds.sort_by { |k| k[:date] }).reverse
    render json:  { filingItems: sortedFilingFeeds }    # needs
  end
end

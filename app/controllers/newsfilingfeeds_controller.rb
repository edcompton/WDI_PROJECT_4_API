class NewsfilingfeedsController < ApplicationController

  def feed
    ticker = params['ticker']
    puts ticker

    yahooUrl = "https://feeds.finance.yahoo.com/rss/2.0/headline?s=#{ticker}&region=US&lang=en-US"

    response = HTTParty.get(yahooUrl)
    data = response.parsed_response

    render json:  { newsItems: data['rss']['channel']['item'] }
  end

end

class NewsfeedsController < ApplicationController

  def watchlist_feed
    tickers = params["_json"].join(',')
    url = "https://feeds.finance.yahoo.com/rss/2.0/headline?s=#{tickers}&region=US&lang=en-US"

    response = HTTParty.get(url)
    data = response.parsed_response

    render json:  { newsItems: data['rss']['channel']['item'] }
  end

end
